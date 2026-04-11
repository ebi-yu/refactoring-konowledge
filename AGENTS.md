## 原則

- TDDで必ずテストコードを先に書いてから実装すること(Red-Green-Refactorサイクル)
- 作業はgit worktreeを切って行うこと
- コミットは小さく、意味のある単位で行うこと
- コミットが完了したらCHANGELOG.mdを更新すること

  ```md
  ## yyyy-mm-dd

  ### [type]

  - <変更内容>
  ```

## プロジェクト固有

- github issueとローカルの`docs/issues`の内容を連携させている
- 連携には`.claude/hooks/update-issues.sh`を使用している。
