{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil # nix LSP
      gopls
      pyright
      typescript-language-server
      vscode-langservers-extracted # html/css/json/eslint
      tailwindcss-language-server
      # Tools
      ripgrep
      fd
      gcc # needed for treesitter compilation
    ];
  };

  # Neovim lua config managed via home-manager's xdg
  xdg.configFile."nvim/init.lua".text = ''
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
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.opt.clipboard = "unnamedplus"
    vim.opt.termguicolors = true
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

    require("lazy").setup({
      -- Colorscheme
      { "catppuccin/nvim", name = "catppuccin", priority = 1000,
        config = function() vim.cmd.colorscheme("catppuccin-mocha") end },

      -- File tree
      { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" } },
        opts = { filesystem = { follow_current_file = { enabled = true } } } },

      -- Fuzzy finder
      { "nvim-telescope/telescope.nvim", branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
          { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
          { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
          { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        } },

      -- Treesitter (highlight/indent are builtin in nvim 0.11, plugin just manages parsers)
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        event = "VeryLazy",
        config = function()
          require("nvim-treesitter.install").install({
            "lua", "nix", "go", "python", "typescript", "javascript",
            "json", "yaml", "markdown", "bash", "html", "css", "tsx", "gomod", "gosum",
          })
        end },

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

      -- AI: GitHub Copilot
      { "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
          suggestion = { enabled = true, auto_trigger = true,
            keymap = { accept = "<M-l>", next = "<M-]>", prev = "<M-[>", dismiss = "<M-h>" } },
          panel = { enabled = true },
        } },

      -- Quality of life
      { "lewis6991/gitsigns.nvim", opts = {} },
      { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
      { "numToStr/Comment.nvim", opts = {} },
      { "nvim-lualine/lualine.nvim", opts = { options = { theme = "catppuccin" } } },
      { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
      { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
    })
  '';
}
