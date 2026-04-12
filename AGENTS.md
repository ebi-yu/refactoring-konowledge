## 参照

開発環境・技術スタック・Vapor Mode など開発全般の情報は **[DEVELOPER.md](./DEVELOPER.md)** を参照。

## コーディング

- TDDで必ずテストコードを先に書いてから実装すること(Red-Green-Refactorサイクル)
- 作業はfeatureブランチをmainから切って行うこと
- コミットは小さく、意味のある単位で行うこと
- コミットが完了したらCHANGELOG.mdを更新すること
- デザインは.pen形式で行うこと

  ```md
  ## yyyy-mm-dd

  ### [type]

  - <変更内容>
  ```

## 開発の進め方

- github issueとローカルの`docs/issues`の内容を連携させている
- 連携には`.claude/hooks/update-issues.sh`を使用している。
- 実装はissuesフォルダ内のepic単位で計画を立てて行うこと
- 画面UIの確認には、`browser-use-cli`を使用すること
- **UI に関わる実装（コンポーネント追加・スタイル変更・レイアウト修正）が完了したら、必ず `browser-use` で実際の表示を確認してから完了とすること**
