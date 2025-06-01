-- ~/.config/nvim/init.lua
-- Consolidated Neovim configuration using lazy.nvim

-- =============================================================================
-- Bootstrap lazy.nvim Package Manager
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- General Editor Settings
-- =============================================================================
-- Appearance
vim.opt.number = true                  -- Show line numbers
vim.opt.termguicolors = true           -- Enable 24-bit RGB color
vim.opt.cursorline = true              -- Highlight the current line
vim.opt.background = "dark"            -- Set background for dark themes
vim.opt.laststatus = 2                 -- Always show the status line
vim.opt.showcmd = true                 -- Show command in the status bar
vim.opt.title = true                   -- Set terminal title
vim.opt.list = true                    -- Show invisible characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Define invisible characters
vim.opt.showmatch = true               -- Highlight matching brackets
vim.opt.signcolumn = "yes"  -- サインカラムを常に表示して固定

-- Behavior
vim.opt.clipboard = vim.opt.clipboard + "unnamedplus" -- Use system clipboard
vim.opt.autoindent = true              -- Enable auto-indent
vim.opt.smartindent = true             -- Enable smart indentation
vim.opt.shiftwidth = 2                 -- Set indentation width to 2 spaces
vim.opt.tabstop = 2                    -- Set tab width to 2 spaces
vim.opt.softtabstop = 2                -- Set soft tab width to 2 spaces
vim.opt.expandtab = true               -- Use spaces instead of tabs
vim.opt.incsearch = true               -- Enable incremental search
vim.opt.smartcase = true               -- Smart case search
vim.opt.ignorecase = true              -- Ignore case in search patterns
vim.opt.wrapscan = true                -- Searches wrap around the end of the file
vim.opt.wrap = true                    -- Wrap lines
vim.opt.inccommand = "split"           -- Show substitution preview in a split window
vim.opt.autoread = true                -- Automatically reload files changed outside of Vim
vim.opt.hidden = true                  -- Allow hidden buffers
vim.opt.virtualedit = "onemore"        -- Allow cursor placement one character beyond the end of the line
vim.opt.shell = "zsh"                  -- Set shell to zsh
vim.opt.iskeyword:remove("_")          -- Treat '_' as part of words

-- File Handling
vim.cmd("set nobackup")                -- Disable backup files
vim.cmd("set noswapfile")              -- Disable swap files

-- Disable Built-in Plugins
vim.g.loaded_netrw = 1                 -- Disable Netrw file explorer
vim.g.loaded_netrwPlugin = 1

-- Markdown Specific Settings (Removed vim-markdown related settings)

-- =============================================================================
-- Key Mappings
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic cursor movement (handle wrapped lines)
map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)
map('v', 'j', 'gj', opts)
map('v', 'k', 'gk', opts)

-- Formatting
map('n', '==', 'gg=G<C-o><C-o>', { noremap = true, silent = true, desc = "Format entire file" })

-- Deletion without yanking
map('n', 'x', '"_x', { noremap = true, silent = true, desc = "Delete character without yanking" })
map('n', 's', '"_s', { noremap = true, silent = true, desc = "Substitute character without yanking" })

-- Nvim-Tree toggle
map("n", "<C-n>", function()
  require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
end, { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Search current word
map("n", "<Space><Space>", "*N", { noremap = true, silent = true, desc = "Search word under cursor" })

-- =============================================================================
-- Autocommands
-- =============================================================================
local group = vim.api.nvim_create_augroup("UserAuCmds", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- IM Select (macOS) - Switch to English layout on leaving insert mode
if vim.fn.has("mac") == 1 then
  autocmd("InsertLeave", {
    group = group,
    pattern = "*",
    command = "silent! !~/bin/im-select com.apple.keylayout.ABC",
    desc = "Switch to ABC layout on leaving insert mode",
  })
end

-- Highlight trailing whitespace
vim.cmd("highlight ExtraWhitespace ctermbg=brown guibg=brown")
local function highlight_trailing_whitespace()
  vim.cmd([[match ExtraWhitespace /\s\+$/]])
end
autocmd({"BufEnter", "InsertLeave", "TextChanged"}, {
  group = group,
  callback = highlight_trailing_whitespace,
  desc = "Highlight trailing whitespace",
})

-- Confirm and trim trailing whitespace on save
local function confirm_trim_trailing_whitespace()
  if vim.fn.search("\\s\\+$", "nw") == 0 then return end -- Exit if no trailing whitespace
  local choice = vim.fn.confirm("Trim trailing whitespace?", "&Yes\n&No", 1) -- Default to Yes
  if choice == 1 then
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local last_search = vim.fn.getreg('/')
    vim.cmd([[%s/\s\+$//e]]) -- Trim whitespace
    vim.fn.setreg('/', last_search) -- Restore last search pattern
    vim.api.nvim_win_set_cursor(0, current_cursor) -- Restore cursor position
  end
end
autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = confirm_trim_trailing_whitespace,
  desc = "Confirm and trim trailing whitespace on save",
})

-- Prevent saving file named only single quote (')
autocmd("BufWriteCmd", {
  group = group,
  pattern = "*",
  callback = function(args)
    local filename = vim.fn.fnamemodify(args.file, ":t")
    if filename == "'" then
      vim.api.nvim_err_writeln("Cannot save file named single quote ('). Aborting.")
      return -- Abort write operation
    end
    -- Proceed with normal write if filename is not just "'"
    vim.cmd("write! " .. vim.fn.fnameescape(args.file))
  end,
  desc = "Prevent saving file named only single quote",
})

-- Check for external file changes more reliably
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = group,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif", -- Avoid checktime in command mode
  desc = "Check for external file changes",
})

-- =============================================================================
-- Plugin Configuration (Lazy.nvim)
-- =============================================================================
require("lazy").setup({
  -- **Core Utilities**
  "nvim-lua/plenary.nvim",              -- Lua utility functions (required by many plugins)

  -- **Syntax & Language Features**
  {
    "nvim-treesitter/nvim-treesitter",    -- Advanced syntax highlighting, indentation, etc.
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        indent = { enable = true, disable = {"go", "wing"} }, -- Enable indentation, disable for specific filetypes
        highlight = {
          enable = true, -- Enable syntax highlighting
          additional_vim_regex_highlighting = { "markdown" }, -- Use Vim regex highlighting for Markdown
        },
        ensure_installed = 'all', -- Install parsers for all supported languages automatically
        auto_install = true, -- Automatically install missing parsers
      })
    end,
  },
  {
  "nvim-treesitter/playground",
  cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
  config = function()
    require("nvim-treesitter.configs").setup({
      playground = {
        enable = true,
        updatetime = 25,
        persist_queries = false,
      },
    })
  end,
},
  "neovim/nvim-lspconfig",              -- Language Server Protocol configuration framework
  "mattn/vim-goimports",                -- Auto-format Go imports on save

  -- **File Management & Icons**
  {
    "nvim-tree/nvim-tree.lua",            -- File explorer
    config = function()
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 30, side = "left" },
        renderer = { group_empty = true }, -- Show empty folders
        filters = { dotfiles = false },    -- Hide dotfiles
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons", -- File icons for nvim-tree and other UI elements
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  "editorconfig/editorconfig-vim",      -- Support for .editorconfig files

  -- **Search & Navigation**
  {
    "nvim-telescope/telescope.nvim",      -- Fuzzy finder for files, buffers, grep, etc.
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup {
        defaults = {
          -- Add any Telescope default configurations here
          -- e.g., layout_strategy = 'vertical', layout_config = { height = 0.8 }
        }
      }
      -- Define Telescope keymaps after setup
      local builtin = require('telescope.builtin')
      map('n', ';f', builtin.find_files, { desc = "Find files" })
      map('n', ';g', builtin.live_grep, { desc = "Live grep" })
      map('n', ';b', builtin.buffers, { desc = "Show buffers" })
    end,
  },

  -- **Code Editing Enhancements**
  "tpope/vim-surround",                 -- Easily manage surrounding pairs (quotes, brackets, etc.)

  -- **UI/UX Enhancements**
  "cocopon/iceberg.vim",                -- Colorscheme (applied after lazy setup)
  {
    "echasnovski/mini.indentscope",       -- Indent guides visualization
    config = function()
      require('mini.indentscope').setup({
        symbol = '│', -- Use a static symbol for indent guides
      })
      -- Customize highlight color for the indent guide symbol
      vim.cmd([[highlight MiniIndentscopeSymbol guifg=grey ctermfg=grey]])
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors", -- Highlight color codes (#rrggbb, rgb(), etc.)
    config = function()
      require('nvim-highlight-colors').setup({})
    end,
  },

  -- **esa Integration**
  {
    '3sho7mi8/esabird.nvim',
    config = function()
      vim.keymap.set('v', '<leader>es', require('esabird').send_to_esa, { desc = 'Send selection to esa.io' })
    end,
  },
  -- **Obsidian Integration**
  {
    "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("obsidian").setup({
        workspaces = {
          { name = "personal", path = "~/obsidian/vault" }, -- Define Obsidian workspace
        },
        templates = {
          folder = "templates", -- Folder for templates
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },
        daily_notes = {
          folder = "daily", -- Folder for daily notes
          default_tags = { "daily" },
          template = "daily.md" -- Template for daily notes
        },
        ui = {
          enable = false
        }
      })
    end,
  },

  -- **LSP Management (Mason)**
  {
    "williamboman/mason.nvim",        -- Manages LSP servers, linters, formatters installation
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = { border = "rounded" }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim", -- Bridges mason.nvim and nvim-lspconfig
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "gopls" },
        automatic_installation = true,

        handlers = {
          function(server_name) -- デフォルトハンドラー
            require("lspconfig")[server_name].setup({})
          end,
          ["lua_ls"] = function() -- lua_ls のカスタム設定
            require("lspconfig").lua_ls.setup({
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                  telemetry = { enable = false },
                },
              },
            })
          end,
        },
      })
    end
  },
  -- **Markdown Rendering** (ここに移動)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require('render-markdown').setup({
        code = {
          enabled = true,
          style = 'full',
        },
        heading = {
          enabled = true,
          sign = false,
          icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
        },
        bullet = {
          icons = { '●', '○', '◆', '◇' },
        },
        checkbox = {
          unchecked = { 
            icon = '☐',
            highlight = 'RenderMarkdownUnchecked',
          },
          checked = { 
            icon = '☒',
            highlight = 'RenderMarkdownChecked',
          },
        },
      })
    end,
  },

}, {
  -- Lazy.nvim options
  ui = {
    border = "rounded", -- Use rounded borders for Lazy UI
  },
})

vim.cmd([[highlight RenderMarkdownUnchecked guifg=#a6accd ctermfg=lightgray]])
vim.cmd([[highlight RenderMarkdownChecked gui=strikethrough cterm=strikethrough]])

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  callback = function()
    -- Set up syntax highlighting for checked checkbox text
    vim.cmd([[
      syntax match MarkdownCheckedText /^\s*- \[x\] .*$/ contains=MarkdownCheckedBox
      syntax match MarkdownCheckedBox /\[x\]/ contained
      highlight MarkdownCheckedText gui=strikethrough cterm=strikethrough
      highlight MarkdownCheckedBox gui=bold guifg=#10b981 cterm=bold ctermfg=green
    ]])
  end,
  desc = "Apply strikethrough to checked checkbox text",
})

-- =============================================================================
-- Apply Colorscheme & Final Adjustments
-- =============================================================================
-- Apply the colorscheme after lazy.nvim has loaded plugins
vim.cmd([[colorscheme iceberg]])

-- Enable transparent background (needs to be after colorscheme)
-- vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
-- vim.cmd([[hi EndOfBuffer guibg=NONE ctermbg=NONE]]) -- Ensure EndOfBuffer is also transparent

-- Ensure conceal level is set (might be overridden by plugins)
-- vim.opt.conceallevel = 0

-- =============================================================================
-- Markdown Configuration
-- =============================================================================
-- Create an autocommand group for Markdown settings
local markdown_group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

-- Set up custom highlighting for Markdown headings
vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  pattern = "markdown",
  callback = function()
    -- Define custom highlight for H1 headings (make them bold)
    vim.cmd([[highlight MarkdownH1 gui=bold guifg=#a6accd term=bold cterm=bold ctermfg=lightblue]])
    
    -- Link Treesitter's @text.title.1.markdown to our custom highlight
    vim.cmd([[highlight link @text.title.1.markdown MarkdownH1]])
    
    -- For fallback without Treesitter
    vim.cmd([[highlight link markdownH1 MarkdownH1]])
  end,
  desc = "Configure custom markdown heading styles",
})

-- =============================================================================
-- Indicate Configuration Loaded
-- =============================================================================
print("Neovim configuration loaded successfully!")
