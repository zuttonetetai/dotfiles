# my dotfiles

[chezmoi](https://github.com/twpayne/chezmoi)で管理

## セットアップ

```bash
# chezmoi のインストールと適用
brew install chezmoi
chezmoi init --apply zuttonetetai

# Neovim (Treesitter) のパーサービルドに必要な依存関係
brew install tree-sitter-cli

# 画像プレビュー依存関係
brew install imagemagick
# 自動で半角にするプラグイン
brew tap laishulu/homebrew
brew install macism
```

### 依存関係について (Neovim 0.12+ / nvim-treesitter main)
最新の `nvim-treesitter` (`main` ブランチ) ではパーサーをコンパイルするために以下が必要です。
- **`tree-sitter-cli`**（`brew install tree-sitter-cli` でインストール）
- **Cコンパイラ**（`clang` / `gcc` 等。macOSの場合は `xcode-select --install` 等でインストールされるコマンドラインツールに含まれます）
- `curl`, `tar`（macOS標準搭載）

