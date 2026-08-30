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
      tree-sitter # CLI used by nvim-treesitter main branch to build parsers
      nodejs # needed by tree-sitter generate for some grammars
    ];
  };

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
}
