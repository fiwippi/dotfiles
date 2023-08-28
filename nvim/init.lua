-- =============================================================================
-- Load Plugins

-- Bootstrap packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- Profile the startup time
  use 'dstein64/vim-startuptime'

  -- Automatically close parenthesis and indent code blocks
  use "windwp/nvim-autopairs"

  -- Better language packs
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require("nvim-treesitter.install").update { with_sync = true } end
  }

  -- Colourscheme
  use 'morhetz/gruvbox'

  -- Improves Haskell syntax highlighting
  use 'dag/vim2hs'

  -- Status bar
  use 'nvim-lualine/lualine.nvim'

  -- Reopen file in same place you closed it at
  use 'farmergreg/vim-lastplace'

  -- Autocompletion for lspconfig
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'

  -- Neovim LSP configuration
  use 'neovim/nvim-lspconfig'

  -- Includes updated version of RustFmt
  use 'rust-lang/rust.vim'

  -- Package manager for neovim
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
  }

  -- Config plugin for mason
  use 'williamboman/mason-lspconfig.nvim'

  -- Snippet engine requited for nvim-cmp
  use{
	"L3MON4D3/LuaSnip",
	tag = "v<CurrentMajor>.*",    -- follow latest release
	run = "make install_jsregexp" -- install jsregexp
  }
  use 'saadparwaiz1/cmp_luasnip'

  -- Comments
  use "terrortylor/nvim-comment"

  -- Show lines for indents
  use "lukas-reineke/indent-blankline.nvim"

  -- Async
  use "nvim-lua/plenary.nvim"

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Automatically recompiles packer
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

-- =============================================================================
-- Neovim settings and mappings
-- https://neovim.io/doc/user/options.html

-- Set the default encoding to utf-8
vim.opt.encoding = "utf-8"

-- Enable true colour
vim.opt.termguicolors = true

-- Enable mouse click
vim.opt.mouse = "a"

-- Stop automatic folding
vim.opt.foldenable = false

-- Enable syntax highlighting
vim.opt.syntax = "on"

-- Disable compatibility to old vi
vim.opt.compatible = false

-- Show line numbers
vim.opt.nu = true

-- Converts tabs to whitespace
vim.opt.expandtab = true

-- Number of columns occupied by a tab
vim.opt.tabstop = 4

-- See multiple spaces as tabstops so backspace (<BS>) does the right thing
vim.opt.softtabstop = 4

-- Number of spaces to use for each step of indent 
vim.opt.shiftwidth = 4

-- Set colourscheme
--
-- Note: gruvbox settings must be set before "colourscheme gruvbox" is called

-- gruvbox - Enable italic text
vim.g.gruvbox_italic = 1

-- gruvbox - Disable bold text
vim.g.gruvbox_bold = 0

-- gruvbox - Set the dark theme contrast to medium
vim.g.gruvbox_contrast_dark = "medium"

-- Set colourscheme background
vim.opt.background = "dark"

-- Set gruvbox colourscheme
vim.cmd("colorscheme gruvbox")

-- Autocompletion of files and commands behaves like shell
vim.opt.wildmode = "list:longest"

-- When scrolling, keep cursor 3 lines away from 
-- screen border when scrolling vertically
vim.opt.scrolloff = 3

-- Display signs in the number column
vim.opt.signcolumn = "number"

-- Hide text under the status line
vim.opt.showmode = false

-- Case insensitive searching unless /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 500

-- Setup smart indenting
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set spell-check language
-- "cjk" stops CJK asian characters from 
-- being marked as spell errors
vim.opt.spelllang = "en,cjk"

-- menuone: Popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + { c = true }

-- Configure diagnostics
vim.diagnostic.config({
  underline = true,         -- Underline the diagnostics
  virtual_text = false,     -- Hides inline diasnostic text
  update_in_insert = false, -- Show diagnostics during insert
  float = {                 -- Formats the float
        border = "none",    -- Removes the lined border
    },
})

-- Automatically show diagonstics on hover
-- vim.api.nvim_create_autocmd("CursorHold", {
--   buffer = bufnr,
--   callback = function()
--     local opts = {
--       focusable = false,
--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--       source = 'always',
--       scope = 'cursor',
--     }
--     vim.diagnostic.open_float(nil, opts)
--   end
-- })

-- ============================================================================
-- Plugin configuration

-- vim2hs - Disable simple conceals
vim.g.haskell_conceal = 0

-- vim2hs - Disable conceals of enumerations
vim.g.haskell_conceal_enumerations = 0

-- indent_blankline
require("indent_blankline").setup()

-- autopairs
require('nvim-autopairs').setup()

-- nvim-comment
require('nvim_comment').setup()

-- treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "vim", "query", "bash", "css", "dockerfile",
                       "gitignore", "go", "gomod", "gosum", "haskell", "json", 
                       "markdown", "python", "javascript", "typescript", "rust"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''}, 
  },
}

-- mason
-- NOTE: npm must be installed on the system for
--       some of the lsps to be installable, e.g.
--       cssls, eslint, tsserver
-- NOTE: ghcup must be installed on the system in
--       order to install hls
require("mason").setup()

-- mason-lspconfig
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
    'cssls',
    'eslint',
    'html',
    'hls',
    'rust_analyzer',
    'tsserver',
  }
})

-- lspconfig and cmp_nvim_lsp
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  -- https://neovim.io/doc/user/lsp.html

  local attach_opts = { buffer = bufnr }
  --local attach_opts = { silent = true, buffer = bufnr }

  -- Go to definition of symbol under cursor
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)

  -- Display documentation about the symbol
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)

  -- Displays signature information about the symbol
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, attach_opts)

  -- Renames all references to the symbol under the cursor
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, attach_opts)

  -- Code actions
  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, attach_opts)

  -- Diagnostics (errors and warnings)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({float = false}) end)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({float = false}) end)
end

-- nvim-lspconfig
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = {
          command = "clippy",
      },
      checkOnSave = "true",
      imports = {
        granularity = {
            group = "module",
        },
      },
    },
  },
}

lspconfig.hls.setup {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
}

lspconfig.tsserver.setup {}

-- nvim_cmp
local cmp = require'cmp'

cmp.setup {
  window = {
    documentation = cmp.config.window.bordered(),
  },
  --
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  --
  enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment") 
          and not context.in_syntax_group("Comment")
      end
  end,
  -- 
  mapping = {
    -- Confirm selection
    ['<Return>'] = cmp.mapping.confirm({select = false}),

    -- Cancel completion
    ['<C-e>'] = cmp.mapping.abort(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    -- Navigate items on the list
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
  },
  --
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip'},
    { name = 'buffer' },
    { name = 'path' }
  }),
}

-- nvim-autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

