{
  description = "char2cs's dotfiles!";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    
    ags.url = "github:Aylur/ags";
    templ.url = "github:a-h/templ";
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    split-monitor-workspaces,
    grub2-themes,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;
    
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
        	grub2-themes.nixosModules.default
        	./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "char2cs@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
