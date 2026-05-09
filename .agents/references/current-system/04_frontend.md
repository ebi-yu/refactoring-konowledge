# フロントエンド解析

旧システムのフロントエンドはJSP（Java Server Pages）によるサーバーサイドレンダリングを基本とし、動的なUI部分にjQueryを使用している。
依存関係にVue.js 2が含まれているが実態はほぼ未使用で、UIの主役はjQueryとBootstrap 3のコンポーネントである。
Bower（2017年廃止）でライブラリを管理し、Gulpでアセットを最適化する構成は現在のエコシステムから大きく乖離している。

## Links

- [[00_current_system_analysis]] - 現状解析サマリ
- [[01_architecture]] - アーキテクチャ概要
- [[07_notification]] - 通知システム（Desktop通知含む）

---

## 技術スタック

| 役割 | 技術 | バージョン | 状態 |
|------|------|---------|------|
| テンプレート | JSP (Java Server Pages) | Servlet 3.1 | ❌ レガシー |
| CSSフレームワーク | Bootstrap | 3.3.6 | ❌ EOL |
| JSライブラリ | jQuery | 2.2.3 | ❌ レガシー |
| リアクティブUI | Vue.js | 2.4.2 | ❌ EOL（実態ほぼ未使用） |
| グラフ | Chart.js | 2.6.0 | △ |
| Markdownレンダリング | MarkedJ（サーバー側） | カスタムfork | ❌ |
| ダイアグラム | Mermaid.js | 8.9.0 | △ |
| 数式 | MathJax | 2.6.1 | △ （KaTeXより重い） |
| パッケージ管理 | Bower | 1.8.14 | ❌ 廃止済み |
| ビルド | Gulp 4 | - | △ |

**重要**: Vue.js 2 は依存関係に含まれているが、実態はほぼ**jQuery中心**の実装。

---

## JSPビュー構成（150+ ファイル）

ビュー層はJSPファイル150本以上で構成される。ページ機能ごとにディレクトリが分かれており、共通パーツは `partials/` と `commons/` に切り出されている。
Markdownレンダリング・コメント一覧・目次などの複雑な表示ロジックはパーシャルJSP（`partials-view-*.jsp`）として独立している。

```
WEB-INF/views/
├── admin/                  # 管理画面（15+ JSP）
│   ├── config/             # システム設定
│   ├── users/              # ユーザー管理
│   ├── webhook/            # Webhook設定
│   ├── mail/               # メール設定
│   ├── mailtemplate/       # メールテンプレート
│   ├── database/           # DB管理
│   └── ldap/               # LDAP設定
│
├── auth/                   # 認証（2 JSP）
│   ├── form.jsp            # ログインフォーム
│   └── auth_error.jsp      # 認証エラー
│
├── open/
│   ├── knowledge/          # 記事閲覧（15+ JSP）
│   │   ├── list.jsp        # 記事一覧
│   │   ├── view.jsp        # 記事詳細
│   │   ├── history.jsp     # 編集履歴
│   │   ├── search.jsp      # 検索
│   │   └── popularity.jsp  # 人気記事
│   ├── account/            # ユーザープロフィール
│   ├── signup/             # 新規登録
│   ├── tag/                # タグ一覧
│   ├── emoji/              # 絵文字ピッカー
│   └── thema/              # テーマ選択
│
├── protect/
│   ├── knowledge/          # 記事作成・編集（9+ JSP）
│   │   ├── edit.jsp        # 作成・編集フォーム
│   │   └── edit_comment.jsp # コメント編集
│   ├── account/            # アカウント設定
│   ├── group/              # グループ管理
│   ├── notification/       # 通知一覧
│   └── stock/              # ストック管理
│
├── partials/               # 共通パーシャル
│   ├── partials-view-main-contents.jsp  # Markdownコンテンツ表示
│   ├── partials-view-comment-list.jsp   # コメント一覧
│   ├── partials-view-toc.jsp            # 目次
│   └── partials-view-menu-buttons.jsp   # アクションボタン群
│
└── commons/
    ├── layout/             # ヘッダー・フッター・ナビ
    └── errors/             # エラーページ（400/401/403/404/500）
```

---

## JavaScriptファイル構成（58ファイル）

カスタムJSは58ファイルで、機能ごとに `knowledge-edit.js`・`knowledge-view.js` 等の命名規則で分かれている。
主要な機能はAJAXによるサーバーAPI呼び出しとDOM操作の組み合わせで実装されており、Vue.jsのリアクティブな状態管理は使われていない。
注目すべき機能として、60秒ごとの自動下書き保存とWebSocketを使ったリアルタイムデスクトップ通知がある。

### コア

| ファイル | 役割 |
|---------|------|
| `common.js` | グローバルユーティリティ（jQuery拡張、アラート、コンテキストパス） |
| `notification.js` | WebSocket接続・Browser通知API・デスクトップ通知 |

### 記事エディタ系

| ファイル | 役割 |
|---------|------|
| `knowledge-edit.js` | 記事作成・編集フォーム、**60秒おきの自動下書き保存** |
| `knowledge-preview.js` | プレビュー生成（サーバーAPI呼び出し） |
| `knowledge-tag-select.js` / `tagselect.js` | タグ選択オートコンプリート |
| `knowledge-target-select.js` / `targetselect.js` | 公開対象グループ・ユーザー選択 |
| `knowledge-emoji-select.js` | 絵文字ピッカー統合 |
| `knowledge-template.js` | テンプレート項目の動的フォーム |
| `knowledge-attachfile.js` | ファイルアップロードUI |

### 記事閲覧系

| ファイル | 役割 |
|---------|------|
| `knowledge-view.js` | 記事詳細ページ全般 |
| `knowledge-view-markdown.js` | Markdownデコレーション、プレゼンテーションモード切替 |
| `knowledge-view-comment.js` | コメントの折りたたみ/展開 |
| `knowledge-view-stock.js` | ブックマーク操作 |
| `knowledge-view-toc.js` | Markdownヘッダーから目次を自動生成 |
| `knowledge-view-attachfile.js` | 添付ファイルダウンロード |
| `comment.js` | コメント投稿・編集・Like |

### その他機能

| ファイル | 役割 |
|---------|------|
| `search.js` | 全文検索UI |
| `event.js` | イベント参加RSVP |
| `survey-edit.js` / `survey-answers.js` | アンケート作成・回答 |
| `slide.js` | スライドデッキビューア |
| `presentation.js` | プレゼンテーションモード |
| `notification-list.js` / `notification-detail.js` | 通知UI |
| `mynotice.js` | ユーザー通知管理 |

---

## Markdownレンダリング

### サーバーサイド（バックエンド）

```
POST /open.knowledge/marked
     ↓
MarkdownLogic.java (MarkedJ)
     ↓
SanitizingLogic.sanitize()  ← OWASP HTMLサニタイズ
     ↓
HTML文字列を返却
```

**MarkedJの拡張機能:**
- Mermaidダイアグラム: ` ```mermaid ` ブロックを `<div class="mermaid">` に変換
- ヘッダーに `markdown-agenda-` プレフィックスのIDを自動付与（目次生成用）
- リンクを `target="_blank"` で開く
- ハードラインブレーク有効

### クライアントサイド

```javascript
// knowledge-view-markdown.js
processDecoration()
  ├─ Mermaid.js でダイアグラムをレンダリング
  ├─ highlight.js でシンタックスハイライト
  ├─ MathJax で数式レンダリング
  └─ プレゼンテーションモード: typeId === '-102' でスライドショー化
```

---

## 主要UIパターン

### 自動下書き保存
```javascript
// knowledge-edit.js
setInterval(function() {
    saveDraft();  // POST /protect.knowledge/draft
}, 60000);        // 60秒ごと
```

### リアルタイム通知（WebSocket）
```javascript
// notification.js
var ws = new WebSocket("ws://{host}/notify");
ws.onmessage = function(event) {
    var data = JSON.parse(event.data);
    showDesktopNotification(data);  // Notification API
};
```

### コメントのコラプス
```javascript
// 状態をサーバーへ永続化
POST /protect.knowledge/collapse
{commentNo: 123, collapse: 1}
```

### ファイル添付（Base64）
```javascript
// アバター画像はBase64エンコードでPOST
POST /protect.account/iconupload
{fileimg: "data:image/png;base64,..."}
```

---

## Cookie管理

| Cookie名 | 用途 |
|---------|------|
| `HISTORY` | 閲覧履歴（直近20件、`-`区切り） |
| `KEYWORD_SORT_TYPE` | 検索ソート設定 |
| `TIME_ZONE_OFFSET` | ユーザーのタイムゾーン（JSで取得してCookieに保存） |
| `LOCALE` | 言語設定 |
| `LOGIN_USER_KEY` | AES暗号化済みの認証Cookie（max-age: 10日） |

---

## 旧フロントエンドの問題点

| 問題 | 詳細 |
|------|------|
| JSP依存 | サーバーサイドレンダリングのみ。SPAや部分更新との相性が悪い |
| jQuery中心 | 手続き的なDOM操作が多く、状態管理が複雑 |
| Vue.js 2 EOL | インストールされているが実態ほぼ未使用、Vue 2自体もEOL |
| Bootstrap 3 | 現在のBootstrap 5と2メジャー差。UIが古い |
| Bower廃止 | フロントエンドパッケージ管理にBower（2017年廃止）を使用 |
| MathJax 2.x | KaTeXと比べてレンダリングが遅い |
| DBへのBlobストレージ | ファイルとアバターをDBのBYTEAに保存（スケーラビリティ問題） |
