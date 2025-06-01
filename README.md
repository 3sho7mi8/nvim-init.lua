# Neovim Configuration

個人用のNeovim設定ファイルです。`lazy.nvim`をパッケージマネージャーとして使用し、単一の`init.lua`ファイルで管理されています。

## 必要要件

- Neovim >= 0.8.0
- Git
- [Nerd Font](https://www.nerdfonts.com/)（アイコン表示用）
- Node.js（LSPサーバー用）
- Python 3（pyrightなどのLSP用）

### macOS固有の要件
- [im-select](https://github.com/daipeihust/im-select)（日本語入力の自動切り替え用）

## インストール

1. 既存のNeovim設定をバックアップ:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

2. このリポジトリをクローン:
```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

3. Neovimを起動:
```bash
nvim
```

初回起動時に`lazy.nvim`が自動的にインストールされ、すべてのプラグインがダウンロードされます。

## 主な機能

### プラグイン管理
- **lazy.nvim**: 高速で柔軟なプラグインマネージャー

### エディタ機能
- **nvim-treesitter**: 高度なシンタックスハイライト
- **nvim-lspconfig + Mason**: 言語サーバーの自動管理
- **telescope.nvim**: ファジーファインダー
- **nvim-tree**: ファイルエクスプローラー
- **render-markdown.nvim**: Markdownの美しいレンダリング

### 開発言語サポート
- **Lua** (lua_ls)
- **Python** (pyright)
- **Go** (gopls + vim-goimports)

### UI/UX
- **iceberg.vim**: ダークカラースキーム
- **mini.indentscope**: インデントガイド
- **nvim-highlight-colors**: カラーコードのハイライト表示

### 統合機能
- **obsidian.nvim**: Obsidianノート管理
- **esabird.nvim**: esa.ioとの連携

## キーマッピング

| キー | 機能 |
|------|------|
| `<C-n>` | ファイルエクスプローラーの開閉 |
| `;f` | ファイル検索（Telescope） |
| `;g` | テキスト検索（Live grep） |
| `;b` | バッファ一覧 |
| `==` | ファイル全体のフォーマット |
| `<Space><Space>` | カーソル下の単語を検索 |
| `j/k` | 折り返し行での自然な移動 |

## 特殊機能

### 自動動作
- **末尾の空白文字**: 保存時に自動検出して削除確認
- **日本語入力**: インサートモード終了時に自動的に英語入力に切り替え（macOS）
- **ファイル変更検出**: 外部でファイルが変更された場合に自動リロード
- **シングルクォートファイル保護**: `'`という名前のファイルの保存を防止

### Markdown機能
- チェックボックスの視覚的表現
- 完了したタスクに取り消し線
- コードブロックのハイライト
- 見出しのアイコン表示

## プラグイン管理コマンド

| コマンド | 説明 |
|----------|------|
| `:Lazy` | プラグイン管理UIを開く |
| `:Lazy update` | プラグインを更新 |
| `:Lazy clean` | 未使用のプラグインを削除 |
| `:Mason` | LSPサーバー管理UIを開く |
| `:LspInfo` | 現在のLSP状態を確認 |

## トラブルシューティング

### プラグインが読み込まれない
```bash
:Lazy
```
を実行してプラグインの状態を確認し、エラーがあれば対処してください。

### LSPが動作しない
```bash
:LspInfo
:Mason
```
で必要なLSPサーバーがインストールされているか確認してください。

### アイコンが正しく表示されない
Nerd Fontがインストールされ、ターミナルで正しく設定されているか確認してください。

## カスタマイズ

設定を変更する場合は、`init.lua`を編集してください。ファイルは以下のセクションに分かれています：

1. lazy.nvimのブートストラップ
2. 一般的なエディタ設定
3. キーマッピング
4. 自動コマンド
5. プラグイン設定
6. カラースキームと最終調整

## ライセンス

個人使用を目的とした設定ファイルです。