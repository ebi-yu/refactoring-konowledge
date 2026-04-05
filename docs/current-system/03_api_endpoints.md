# APIエンドポイント・コントローラ解析

旧システムのルーティングはSpring MVCのようなアノテーションベースではなく、URLのプレフィックス（スコープ）とクラス名・メソッド名の命名規則でマッピングされる独自方式を採用している。
`/open.knowledge/list` であれば `open` スコープの `KnowledgeControl` クラスの `list()` メソッドが呼ばれる。
このシンプルな規則のおかげでURLとコードの対応が直感的だが、フレームワーク固有の知識が必要なため外部から理解しにくい。

## Links

- [[00_current_system_analysis]] - 現状解析サマリ
- [[01_architecture]] - アーキテクチャ概要
- [[05_auth_security]] - 認証・認可詳細

---

## ルーティングの仕組み

URLスコープによってアクセスレベルが決まる。`open` は認証不要の公開エンドポイント、`protect` はログイン必須、`admin` は管理者ロールが必要、`api` はRESTAPIトークン認証で動作する。
フィルターチェーンの `AuthenticationFilter` がスコープに応じて認証を強制し、`ControlFilter` がリフレクションでコントローラを呼び出す。

URLは **`/スコープ.クラス名/メソッド名/[パスパラメータ]`** という規則に基づく。

| スコープ | 認証要否 | 例 |
|---------|---------|---|
| `open` | 不要（公開） | `/open.knowledge/list` |
| `protect` | 要（ログイン済み） | `/protect.knowledge/save` |
| `admin` | 要（管理者ロール） | `/admin.users/list` |
| `api` | トークン認証 | `/api/knowledges` |

### フィルターチェーン（実行順）

```
1. EncodingFilter      - UTF-8 強制
2. SeqFilter           - シーケンシャルID付与
3. LoggingFilter       - アクセスログ
4. ApiFilter           - APIリクエスト前処理
5. AuthenticationFilter - セッション認証
6. MultipartFilter     - ファイルアップロード
7. MaintenanceModeFilter - メンテナンス制御
8. ControlFilter       - メインルーティング
```

### 認証スキップパス

```
/index, /open/*, /api/*, /template/*, /bower/*, 静的リソース
```

---

## トークンセキュリティ

| トークン種別 | 用途 |
|------------|------|
| `publishToken` | GETリクエスト（参照系）の検証 |
| `subscribeToken` | POST/PUT/DELETE（更新系）のCSRF検証 |
| `checkReqToken` | フォームのCSRFトークン検証 |
| `checkReferer` | Refererヘッダ検証 |

---

## 公開コントローラ（open）

### open.Knowledge `/open.knowledge/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `list()` | `/open.knowledge/list/{offset}` | GET | 記事一覧（keyword/tag/group/user/template でフィルタ） |
| `view()` | `/open.knowledge/view/{knowledgeId}` | GET | 記事詳細（コメント・Like・ストック表示） |
| `like()` | `/open.knowledge/like/{knowledgeId}` | POST | Likeの付与 → `{knowledgeId, count}` |
| `likecomment()` | `/open.knowledge/likecomment/{commentNo}` | POST | コメントへのLike → `{count}` |
| `marked()` | `/open.knowledge/marked` | POST | タイトル+本文をMarkdown→HTMLに変換して返却 |
| `escape()` | `/open.knowledge/escape` | POST | HTML エスケープ |
| `search()` | `/open.knowledge/search` | GET | 検索フォーム表示 |
| `histories()` | `/open.knowledge/histories/{knowledgeId}/{offset}` | GET | 編集履歴一覧 |
| `history()` | `/open.knowledge/history/{knowledgeId}` | GET | 特定バージョンのdiff表示 |
| `show_popularity()` | `/open.knowledge/show_popularity` | GET | 人気記事top20 |
| `show_unread()` | `/open.knowledge/show_unread/{offset}` | GET | 未読記事 |
| `stocks()` | `/open.knowledge/stocks/{offset}` | GET | ストック（ブックマーク）一覧 |
| `events()` | `/open.knowledge/events` | GET | イベント一覧（日付指定） |
| `show_history()` | `/open.knowledge/show_history` | GET | 閲覧履歴（cookie基準） |
| `template()` | `/open.knowledge/template` | GET | テンプレートJSON取得 |
| `items()` | `/open.knowledge/items` | GET | 記事のオートコンプリート |
| `likes()` | `/open.knowledge/likes/{knowledgeId}/{offset}` | GET | Like したユーザー一覧 |

### open.Account `/open.account/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `icon()` | `/open.account/icon/{userId}` | GET | アバター画像（なければIdenticonを生成） |
| `info()` | `/open.account/info/{userId}` | GET | ユーザープロフィール＋記事一覧 |
| `cp()` | `/open.account/cp/{userId}` | GET | 貢献ポイント履歴 JSON |
| `knowledge()` | `/open.account/knowledge/{userId}` | GET | ユーザーの記事一覧 JSON |
| `activity()` | `/open.account/activity/{userId}` | GET | アクティビティ履歴 JSON |

### open.Signup `/open.signup/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `view()` | `/open.signup/view` | GET | 登録フォーム |
| `save()` | `/open.signup/save` | POST | 新規登録処理 |
| `activate()` | `/open.signup/activate/{token}` | GET | メール認証（招待）リンクの処理 |

**登録モード（SystemConfig.USER_ADD_TYPE）:**

| モード | 挙動 |
|--------|------|
| ADMIN | 管理者のみユーザー追加可 |
| USER | 自由登録 |
| MAIL | 招待メールによるダブルオプトイン |
| APPROVE | ユーザー申請 → 管理者承認 |

### その他 open コントローラ

| コントローラ | パス | 概要 |
|------------|------|------|
| TagControl | `/open.tag/*` | タグ閲覧 |
| FileControl | `/open.file/*` | ファイルダウンロード・スライド表示 |
| EventControl | `/open.event/*` | イベント管理 |
| SurveyControl | `/open.survey/*` | アンケート参加 |
| NoticeControl | `/open.notice/*` | システムお知らせ |
| PasswordInitializationControl | `/open.PasswordInitialization/*` | パスワードリセット |
| LanguageControl | `/open.language/*` | 言語切替 |
| EmojiControl | `/open.emoji/*` | 絵文字サポート |
| KnowledgeSearchControl | `/open.api/KnowledgeSearch/*` | 検索API |
| UserApiControl | `/open.api/User/*` | ユーザーAPI |

---

## 認証済みコントローラ（protect）

### protect.Knowledge `/protect.knowledge/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `view_add()` | `/protect.knowledge/view_add` | GET | 記事作成フォーム |
| `view_edit()` | `/protect.knowledge/view_edit/{knowledgeId}` | GET | 記事編集フォーム |
| `save()` | `/protect.knowledge/save/{knowledgeId}` | POST | 記事の作成・更新 |
| `draft()` | `/protect.knowledge/draft` | POST | 下書き保存 → `{draftId}` |
| `delete()` | `/protect.knowledge/delete` | POST | 記事削除 |
| `comment()` | `/protect.knowledge/comment/{knowledgeId}` | POST | コメント投稿（ファイル添付対応） |
| `edit_comment()` | `/protect.knowledge/edit_comment/{commentNo}` | GET | コメント編集フォーム |
| `update_comment()` | `/protect.knowledge/update_comment` | POST | コメント更新 |
| `delete_comment()` | `/protect.knowledge/delete_comment/{commentNo}` | GET | コメント削除 |
| `stock()` | `/protect.knowledge/stock/{knowledgeId}` | POST | ストック（ブックマーク）操作 |
| `view_targets()` | `/protect.knowledge/view_targets/{knowledgeId}` | GET | 公開対象の取得 JSON |
| `collapse()` | `/protect.knowledge/collapse` | POST | コメントのスレッド折りたたみ |

**パーミッションチェック:**
- 編集：記事作成者 or 編集者として追加されたユーザーのみ
- コメント：記事の閲覧権限があるユーザー

### protect.Account `/protect.account/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `index()` | `/protect.account/index` | GET | アカウント設定画面 |
| `update()` | `/protect.account/update` | POST | アカウント情報更新 |
| `withdrawal()` | `/protect.account/withdrawal` | GET | アカウント削除確認 |
| `delete()` | `/protect.account/delete` | POST | アカウント削除（不可逆） |
| `iconupload()` | `/protect.account/iconupload` | POST | アバター画像アップロード（base64 PNG） |
| `changekey()` | `/protect.account/changekey` | GET | メールアドレス変更フォーム |
| `changerequest()` | `/protect.account/changerequest` | POST | メールアドレス変更リクエスト |
| `confirm_mail()` | `/protect.account/confirm_mail/{token}` | GET | メールアドレス変更確認リンク |
| `targets()` | `/protect.account/targets` | GET | デフォルト公開範囲設定 |
| `savetargets()` | `/protect.account/savetargets` | POST | デフォルト公開範囲保存 |

### protect.Group `/protect.group/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `mygroups()` | `/protect.group/mygroups/{offset}` | GET | 所属グループ一覧 |
| `list()` | `/protect.group/list/{offset}` | GET | 全グループ一覧 |
| `view_add()` | `/protect.group/view_add` | GET | グループ作成フォーム |
| `add()` | `/protect.group/add` | POST | グループ作成 |
| `view()` | `/protect.group/view/{groupId}` | GET | グループ詳細 |
| `edit()` | `/protect.group/edit/{groupId}` | GET | グループ編集フォーム |
| `update()` | `/protect.group/update` | POST | グループ更新 |
| `delete()` | `/protect.group/delete` | POST | グループ削除 |
| `members()` | `/protect.group/members/{groupId}` | GET | メンバー一覧 |
| `add_member()` | `/protect.group/add_member` | POST | メンバー追加 |
| `remove_member()` | `/protect.group/remove_member` | POST | メンバー除外 |

### その他 protect コントローラ

| コントローラ | パス | 概要 |
|------------|------|------|
| DraftControl | `/protect.draft/*` | 下書き管理 |
| FileControl | `/protect.file/*` | ファイルアップロード・削除 |
| NotificationControl | `/protect.notification/*` | 通知管理 |
| NotifyControl | `/protect.notify/*` | 通知設定 |
| StockControl | `/protect.stock/*` | ストック・コレクション管理 |
| TokenControl | `/protect.token/*` | APIトークン管理 |
| EventControl | `/protect.event/*` | イベント管理（認証済み） |
| SurveyControl | `/protect.survey/*` | アンケート参加 |
| ConfigControl | `/protect.config/*` | ユーザー設定 |

---

## 管理者コントローラ（admin）

すべてのメソッドに `@Auth(roles = "admin")` が付与されている。

### admin.Users `/admin.users/*`

| メソッド | パス | HTTP | 概要 |
|--------|------|------|------|
| `list()` | `/admin.users/list/{offset}` | GET | ユーザー一覧（keyword フィルタ） |
| `view_add()` | `/admin.users/view_add` | GET | ユーザー作成フォーム |
| `create()` | `/admin.users/create` | POST | ユーザー作成 |
| `view_edit()` | `/admin.users/view_edit/{userId}` | GET | ユーザー編集フォーム |
| `save()` | `/admin.users/save` | POST | ユーザー更新 |
| `delete()` | `/admin.users/delete` | POST | ユーザー削除 |
| `accept_list()` | `/admin.users/accept_list` | GET | 仮登録承認待ち一覧 |
| `accept()` | `/admin.users/accept/{token}` | GET | 仮登録承認 |
| `accept_delete()` | `/admin.users/accept_delete/{token}` | GET | 仮登録拒否 |

### その他 admin コントローラ

| コントローラ | パス | 概要 |
|------------|------|------|
| ConfigControl | `/admin.config/*` | システム設定 |
| DatabaseControl | `/admin.database/*` | DB管理・マイグレーション |
| LdapControl | `/admin.ldap/*` | LDAP/AD設定 |
| MailControl | `/admin.mail/*` | メール設定 |
| MailTemplateControl | `/admin.mailtemplate/*` | メールテンプレート管理 |
| MailhookControl | `/admin.mailhook/*` | メール→記事変換設定 |
| NoticeControl | `/admin.notice/*` | システムお知らせ管理 |
| PinControl | `/admin.pin/*` | ピン留め管理 |
| ProxyControl | `/admin.proxy/*` | プロキシ設定 |
| TemplateControl | `/admin.template/*` | 記事テンプレート管理 |
| WebhookControl | `/admin.webhook/*` | Webhook管理 |
| AggregateControl | `/admin.aggregate/*` | データ集計 |

---

## REST API（/api）

### GET /api/knowledges

```
Query: limit, offset, keyword, tags, groups, template
Response: Knowledge[]
```

### GET /api/knowledges/{id}

```
Response: Knowledge | 404
```

### POST /api/knowledges

```
Body: KnowledgeDetail (JSON)
Response: {name: title, id: knowledgeId} (201)
```

### PUT /api/knowledges/{id}

```
Body: KnowledgeDetail (JSON)
Response: {msg: "updated"} (200)
```

### DELETE /api/knowledges/{id}

```
Response: {msg: "deleted"} (200)
```

### GET /api/users / GET /api/users/{id}

```
Response: User[] | UserDetail
```

### GET /api/groups / GET /api/groups/{id}

```
# サブリソース対応
/api/groups/{id}/knowledges → グループ内記事
/api/groups/{id}/users     → グループメンバー
```

### GET /api/drafts / DELETE /api/drafts/{id}

```
Response: Draft[] | 200/204/403/404
```

### GET /api/attachments/{id}

```
Response: ファイルバイナリ | 404
```

---

## HTTPステータスコード

| コード | 使用場面 |
|-------|---------|
| 200 | 成功 |
| 201 | リソース作成成功 |
| 204 | コンテンツなし |
| 400 | バリデーションエラー |
| 401 | 未認証 |
| 403 | 権限なし |
| 404 | リソース未発見 |
| 500 | サーバーエラー |
| 501 | 未実装 |

---

## Cookie管理

| Cookie名 | 用途 |
|---------|------|
| `HISTORY` | 閲覧履歴（直近20件、`-`区切り） |
| `KEYWORD_SORT_TYPE` | 検索結果ソート設定 |
| `TIME_ZONE_OFFSET` | ユーザーのタイムゾーンオフセット |
| `LOCALE` | 言語設定 |
