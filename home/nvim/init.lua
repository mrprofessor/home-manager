-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
-- No truecolor: nvim emits the 16 ANSI slots so Ghostty's theme (and its
-- light/dark auto-switch) decides every color. Do not set a colorscheme.
vim.opt.termguicolors = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.mouse = "a"

-- Neovim's default scheme defines most groups with guifg only, so with
-- termguicolors off they fall through to plain foreground. Map the bare ones
-- onto ANSI *slots*, never hexes, so Ghostty's active theme still picks the
-- real colors and keeps following its light/dark switch.
-- Keyword links to Statement, and Number/Boolean link to Constant, so those
-- inherit. String/Identifier/Function/Diagnostic* already ship a ctermfg.
for group, hl in pairs({
  Comment   = { ctermfg = 8 },              -- grey
  Statement = { ctermfg = 5, bold = true }, -- keep core's bold
  Type      = { ctermfg = 6 },
  Constant  = { ctermfg = 3 },
  PreProc   = { ctermfg = 5 },

  -- Backgrounds. Without these the cmp popup and LSP/telescope floats render
  -- straight over the buffer text. MatchParen uses reverse so it needs no slot
  -- and inverts correctly in both light and dark. FloatBorder links to
  -- NormalFloat, so it follows.
  MatchParen  = { reverse = true },
  Pmenu       = { ctermbg = 8 },
  NormalFloat = { ctermbg = 8 },
  Folded      = { ctermfg = 8 },
}) do
  vim.api.nvim_set_hl(0, group, hl)
end

require("lazy").setup({
  -- No colorscheme by design; see termguicolors above.

  -- File tree
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" } },
    opts = { filesystem = { follow_current_file = { enabled = true }, filtered_items = { visible = true } } } },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    } },

  -- Treesitter (main branch: setup() no longer takes ensure_installed, and
  -- highlighting must be started per buffer via vim.treesitter.start)
  -- Pinned: newer commits require nvim 0.12+ (vim.list.unique); drop the
  -- commit pin once neovim >= 0.12
  { "nvim-treesitter/nvim-treesitter", branch = "main",
    commit = "90cd6580e720caedacb91fdd587b747a6e77d61f", build = ":TSUpdate",
    lazy = false,
    config = function()
      local langs = {
        -- general
        "lua", "nix", "python", "typescript", "javascript", "tsx",
        "json", "yaml", "toml", "xml", "markdown", "markdown_inline",
        "bash", "html", "css", "swift", "haskell", "rust",
        -- ~/kai (.feature files use builtin cucumber syntax; no gherkin parser)
        "go", "gomod", "gosum", "gotmpl", "helm", "sql",
        "c_sharp", "bicep", "terraform", "hcl", "powershell",
        "dockerfile", "make", "astro", "svelte", "gitignore", "gitattributes",
      }
      require("nvim-treesitter").install(langs)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          -- no parser for this filetype: fall back to legacy syntax quietly
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end },

  -- Amber (.ab) syntax; no treesitter parser exists for it
  { "amber-lang/amber-vim" },

  -- Org (~/labs/blog); ships its own treesitter grammar, not in the registry
  { "nvim-orgmode/orgmode", ft = "org", opts = {} },

  -- LSP
  { "neovim/nvim-lspconfig",
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "lua_ls", "nil_ls", "gopls", "pyright", "ts_ls", "html", "cssls", "tailwindcss" }
      for _, s in ipairs(servers) do
        vim.lsp.config(s, { capabilities = caps })
        vim.lsp.enable(s)
      end
      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(k, f, d) vim.keymap.set("n", k, f, { buffer = ev.buf, desc = d }) end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
        end,
      })
    end },

  -- Autocompletion
  { "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" }, { name = "path" } }
        ),
      })
    end },

  -- Quality of life
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
})
