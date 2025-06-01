# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration repository using `lazy.nvim` as the plugin manager. The configuration is contained in a single `init.lua` file with a modular, well-organized structure.

## Common Commands

### Plugin Management
- **Update plugins**: Open Neovim and run `:Lazy update`
- **Install new plugins**: Add plugin spec to the `require("lazy").setup({...})` section in init.lua, then restart Neovim
- **Check plugin status**: `:Lazy`
- **Clean unused plugins**: `:Lazy clean`

### LSP and Mason Commands
- **Install LSP servers**: `:Mason` (UI will open)
- **Update LSP servers**: `:MasonUpdate`
- **Check LSP status**: `:LspInfo`

### Development Workflow
- **Format entire file**: Press `==` in normal mode
- **Toggle file explorer**: `Ctrl+n`
- **Find files**: `;f` (Telescope)
- **Live grep**: `;g` (Telescope)
- **Search word under cursor**: `Space Space`

## Architecture and Structure

### init.lua Organization
The configuration follows this structure:
1. **Bootstrap lazy.nvim** (lines 5-18): Auto-installs the plugin manager
2. **General Editor Settings** (lines 21-65): Core Neovim options
3. **Key Mappings** (lines 68-92): Custom keybindings
4. **Autocommands** (lines 95-162): Auto-behaviors like trailing whitespace handling
5. **Plugin Configuration** (lines 166-372): Plugin declarations and configurations
6. **Post-setup** (lines 395-431): Colorscheme and final adjustments

### Key Plugin Categories
- **LSP Management**: mason.nvim, mason-lspconfig.nvim, nvim-lspconfig
- **File Navigation**: nvim-tree, telescope.nvim
- **Syntax**: nvim-treesitter (with playground for debugging)
- **Markdown**: render-markdown.nvim with custom styling
- **UI**: iceberg.vim colorscheme, mini.indentscope, nvim-highlight-colors

### Special Features
1. **Trailing Whitespace Management**: Automatically highlights and prompts to remove on save
2. **macOS Input Method**: Auto-switches to English on leaving insert mode
3. **Protection Against Accidental Files**: Prevents saving files named just `'`
4. **Markdown Enhancements**: Custom rendering with strikethrough for completed tasks

## Testing and Validation

### Syntax Checking
- **Check Lua syntax**: Use `luacheck init.lua` (requires luacheck installed)
- **Treesitter inspection**: `:TSPlaygroundToggle` to debug syntax highlighting

### Configuration Validation
- After any changes to init.lua, restart Neovim and check for errors
- Look for the "Neovim configuration loaded successfully!" message
- Check `:messages` for any errors during startup

## Important Considerations

1. **Plugin Updates**: When updating plugins, check the lazy-lock.json for version changes
2. **LSP Servers**: The config auto-installs lua_ls, pyright, and gopls
3. **File Icons**: Requires a Nerd Font for proper display
4. **Obsidian Integration**: Configured for `~/obsidian/vault` path
5. **Go Development**: Auto-formats imports on save via vim-goimports