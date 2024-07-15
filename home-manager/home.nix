# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "char2cs";
    homeDirectory = "/home/char2cs";
  };
  
  home.file = {
    ".config/hypr/NixWallpaper.png".source  = ./hypr/NixWallpaper.png;
    ".config/hypr/hypridle.conf".source     = ./hypr/hypridle.conf;
    ".config/hypr/hyprlock.conf".source     = ./hypr/hyprlock.conf;
    ".config/hypr/hyprpaper.conf".source    = ./hypr/hyprpaper.conf;

    ".config/kitty".source                  = ./kitty;

    ".config/Scripts/song-status".source    = ./hypr/Scripts/song-status;
    ".config/Scripts/network-status".source = ./hypr/Scripts/network-status;
    ".config/Scripts/battery-status".source = ./hypr/Scripts/battery-status;
    ".config/Scripts/layout-status".source  = ./hypr/Scripts/layout-status;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.whitesur-cursors;
    name = "WhiteSur-gtk-theme";
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3-dark";
    theme.package = pkgs.adw-gtk3;
    cursorTheme.package = pkgs.whitesur-cursors;
    cursorTheme.name = "WhiteSur-gtk-theme";
    iconTheme.package = pkgs.whitesur-icon-theme;
    iconTheme.name = "WhiteSur-gtk-theme";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ 
  	steam 
    discord
  	swaybg
  	dunst
  	go
  	nodejs
  	cargo
  	unzip
	  vscode
  ];

  # Enable home-manager and git
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        #"NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        #"MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        #"MOZ_WEBRENDER,1"
        # misc
        #"_JAVA_AWT_WM_NONREPARENTING,1"
        #"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        #"QT_QPA_PLATFORM,wayland"
        #"SDL_VIDEODRIVER,wayland"
        #"GDK_BACKEND,wayland"
      ];
    };
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
  };

  programs = {
    home-manager.enable = true;
    ags = {
      enable = true;
      configDir = ./ags;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    btop.enable = true;
    waybar.enable = true;
    starship.enable = true;
    kitty.enable = true;
    ripgrep.enable = true;

    git = {
      enable = true;
      userName = "char2cs";
      userEmail = "char2cs@rounds.com.ar";
    }; 

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nano";
      };
    };

    firefox.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
