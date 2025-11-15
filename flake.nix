{
  description = "MacOS Nix Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }@inputs:
    let
      system = "aarch64-darwin";
    in {
      # ------------------------
      # Home Manager
      # ------------------------
      homeConfigurations = {
        prof = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { 
            inherit system;
            config.allowUnfree = true;
          };

          modules = [
            ./home
          ];
        };
      };

      # ------------------------
      # nix-darwin (for system-level config + homebrew)
      # ------------------------
      darwinConfigurations.my-mac = nix-darwin.lib.darwinSystem {
        inherit system;
        
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./darwin
        ];
      };
    };
}
