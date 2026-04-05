# 認証・認可・セキュリティ解析

認証・認可はSpring Securityのような標準フレームワークを使わず、カスタムのFilterとLogicクラスで実装されている。
セッションベースの認証を基本とし、Cookie暗号化によるリメンバーミー機能を持つ。
RBACは「ロール→機能」の2段マッピングで実現されており、DB管理されているため管理画面から動的に変更できる。

## Links

- [[00_current_system_analysis]] - 現状解析サマリ
- [[01_architecture]] - アーキテクチャ概要
- [[02_domain_model]] - 関連テーブル（USERS, ROLES, FUNCTIONS等）

---

## 認証フロー

ログイン失敗時に2秒の強制スリープを入れることでブルートフォース攻撃を抑制している。
認証成功後はユーザー情報・ロール・グループを一括でSessionに保存し、以降のリクエストはSessionから復元する。

```mermaid
sequenceDiagram
    actor U as ユーザー
    participant F as AuthFilter
    participant L as DBAuthLogic
    participant DB as USERS Table
    participant S as Session

    U->>F: POST /signin (userKey, password)
    F->>L: authenticate(userKey, password)
    L->>DB: SELECT password, salt WHERE user_key=?
    DB-->>L: passwordハッシュ + salt
    L->>L: PBKDF2検証

    alt 認証失敗
        L-->>F: null
        F->>F: sleep(2秒) ブルートフォース抑制
        F-->>U: ログインエラー
    else 認証成功
        L->>DB: SELECT roles, groups
        DB-->>L: ロール・グループ一覧
        L->>S: LoginedUser をセット
        Note over S: LOGIN_USER_ID_SESSION_KEY<br/>LOGIN_ROLE_IDS_SESSION_KEY<br/>LOGIN_USER_INFO_SESSION_KEY
        L->>U: AES暗号化Cookie をセット（10日間）
        F-->>U: リダイレクト（元のURL）
    end
```

### セッションの内容

`LoginedUser` オブジェクトには認証後に必要な情報をすべて詰め込んでいる。これにより各リクエストでDB問い合わせを省くが、グループやロールが変更されてもセッションが切れるまで反映されない問題がある。

```
LoginedUser（Session保存オブジェクト）
  ├─ UsersEntity     ユーザーID・Key・Name・Mail等
  ├─ List<Roles>     グローバルロール一覧
  ├─ List<Groups>    所属グループ一覧
  └─ Locale          言語設定
```

### Cookie認証（リメンバーミー）

セッションが切れた際のフォールバックとして動作する。内容はAES暗号化されているため平文では保存されないが、キーが漏洩すると任意のユーザーとしてログインできる点は注意が必要。

| 項目 | 設定値 |
|------|--------|
| Cookie名 | `LOGIN_USER_KEY` |
| 内容 | `UserSecret { userKey, userName, email }` をAES暗号化 |
| Max-Age | 10日 |
| 暗号化キー | アプリ起動時に24文字ランダム生成 |

---

## パスワード管理

パスワードはユーザーごとにランダムソルトを生成し、PBKDF2-likeのハッシュで保存する。
反復回数・ビット数は `HASH_CONFIGS` テーブルで管理されているため、管理画面から変更可能。

| 項目 | 詳細 |
|------|------|
| ハッシュ方式 | PBKDF2-like（反復回数・ビット数はHASH_CONFIGSで設定） |
| ソルト | ユーザー別にランダム生成、USERSテーブルのSALTカラムに保存 |
| 可逆暗号化（設定値） | LDAP_CONFIGS, PROXY_CONFIGS, MAIL_CONFIGSのパスワードはAES暗号化 |

---

## RBAC（ロールベースアクセス制御）

3層構造でURLレベルのアクセス制御を実現している。機能とロールのマッピングはDB管理なので、コード変更なく権限設定を変更できる点は利点。

```mermaid
flowchart LR
    U["USERS"] -->|USER_ROLES| R["ROLES"]
    R -->|ROLE_FUNCTIONS| F["FUNCTIONS\n（URLパスパターン）"]

    subgraph Check["リクエスト認可チェック"]
        direction TB
        C1["リクエストURLと\nFUNCTION_KEYを照合"]
        C2{"一致するFunction\nが存在する？"}
        C3["許可ロールIDと\nログインユーザーのロールを比較"]
        C4["✅ アクセス許可"]
        C5["❌ 403 Forbidden"]

        C1 --> C2
        C2 -->|なし| C4
        C2 -->|あり| C3
        C3 -->|ロールが一致| C4
        C3 -->|不一致| C5
    end

    F --> Check
```

### 記事レベルのアクセス制御

グローバルなRBACとは別に、記事単位でユーザー・グループへの閲覧/編集権限を設定できる。Lucene検索時にもこのアクセス制御がクエリに組み込まれ、権限のない記事は検索結果に現れない。

| テーブル | 用途 |
|---------|------|
| KNOWLEDGE_USERS | 閲覧可能ユーザー |
| KNOWLEDGE_GROUPS | 閲覧可能グループ |
| KNOWLEDGE_EDIT_USERS | 編集可能ユーザー |
| KNOWLEDGE_EDIT_GROUPS | 編集可能グループ |

---

## LDAP認証

企業内Active DirectoryとのSSO連携機能。`AUTH_TYPE` で「DBのみ」「LDAPのみ」「DB+LDAPフォールバック」を切り替えられる。

```mermaid
sequenceDiagram
    participant U as ユーザー
    participant L as LdapLogic
    participant AD as LDAP/AD

    U->>L: ユーザーID + パスワード
    L->>AD: サービスアカウントでバインド
    L->>AD: ユーザーDN検索（フィルター条件）
    AD-->>L: ユーザーのDN
    L->>AD: 見つかったDNでバインド（パスワード確認）
    alt 認証成功
        L->>AD: ADMIN_CHECK_FILTER で管理者判定
        L->>AD: NAME_ATTR, MAIL_ATTR でユーザー情報取得
        AD-->>L: 名前・メールアドレス
        L-->>U: 認証OK（DBにユーザー作成/更新）
    else 認証失敗
        AD-->>L: 認証エラー
        L-->>U: ログインエラー
    end
```

### LDAP設定項目

| 項目 | 説明 |
|------|------|
| HOST / PORT | LDAPサーバー（389=LDAP, 636=LDAPS） |
| USE_SSL / USE_TLS | セキュア接続フラグ |
| BIND_DN / BIND_PASSWORD | サービスアカウント（AES暗号化保存） |
| BASE_DN | ユーザー検索のベースDN |
| FILTER | ユーザー検索フィルター（例: `(uid={userid})`） |
| ID_ATTR | ログインID属性（例: `uid`, `sAMAccountName`） |
| ADMIN_CHECK_FILTER | 管理者昇格判定フィルター |

---

## CSRF保護

二重Cookie検証パターンを採用している。セッション側とCookie側の両方にトークンを保存し、POSTリクエスト時に照合する。加えて隠しフォームパラメータによる第二の検証も可能。

```mermaid
flowchart TD
    subgraph GET["GETリクエスト（フォーム表示時）"]
        G1["CSRFTokens をセッションに保存"]
        G2["Base64暗号化してCookieにもセット"]
        G3["隠しフォームパラメータ __REQ_ID_KEY を埋め込み"]
    end

    subgraph POST["POSTリクエスト（フォーム送信時）"]
        P1["Cookieのトークン取得"]
        P2["セッションのトークンと照合"]
        P3{"一致？"}
        P4["✅ 処理続行"]
        P5["❌ CSRF検証エラー"]
    end

    GET --> POST
    P1 --> P2 --> P3
    P3 -->|一致| P4
    P3 -->|不一致| P5
```

コントローラのアノテーションで検証レベルを細かく設定できる：

```java
@Post(
    subscribeToken = "knowledge",  // CSRF検証有効
    checkReferer   = true,         // Refererヘッダ確認
    checkReqToken  = true          // 隠しパラメータも検証
)
```

---

## セキュリティ対策まとめ

旧システムは標準フレームワークを使わない分、個別実装のリスクはあるが基本的なセキュリティ対策は網羅している。

| 脅威 | 対策 | 実装 |
|------|------|------|
| パスワード漏洩 | PBKDF2-likeハッシュ + ユーザー別ソルト | `PasswordUtil` |
| ブルートフォース | ログイン失敗時2秒スリープ | `AuthenticationFilter` |
| CSRF | 二重Cookieパターン + 隠しパラメータ | `HttpRequestCheckLogic` |
| XSS | OWASPサニタイザーでMarkdown出力をサニタイズ | `SanitizingLogic` |
| 機密設定の平文保存 | LDAP/SMTP/ProxyパスワードはAES暗号化 | 各ConfigsEntity |
| セッション固定 | ログイン時にセッションIDを再生成 | `AbstractAuthenticationLogic` |
