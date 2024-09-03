# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ... 
}:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	nix.settings = {
		experimental-features = "nix-command flakes";
		auto-optimise-store = true;
	};

	nixpkgs = {
		overlays = [
			inputs.templ.overlays.default
			outputs.overlays.additions
			outputs.overlays.modifications
			outputs.overlays.unstable-packages
			inputs.templ.overlays.default
		];
		config = {
			allowUnfree = true;
			nvidia.acceptLicense = true;
		};
	};

	# Boot
	boot.loader = {
		grub2-theme = {
			enable = true;
			theme = "vimix";
			footer = true;
		};
		
		systemd-boot.enable = false;
		
		efi = {
			canTouchEfiVariables = false;
		};

		grub = {
			enable = true;
			efiSupport = true;
			# efiInstallAsRemovable = true;
			devices = ["nodev"];
			useOSProber = true;
		};	
	};

	boot.kernelParams = [ "mem_sleep_default=deep" ];

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Argentina/Buenos_Aires";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "es_AR.UTF-8";
		LC_IDENTIFICATION = "es_AR.UTF-8";
		LC_MEASUREMENT = "es_AR.UTF-8";
		LC_MONETARY = "es_AR.UTF-8";
		LC_NAME = "es_AR.UTF-8";
		LC_NUMERIC = "es_AR.UTF-8";
		LC_PAPER = "es_AR.UTF-8";
		LC_TELEPHONE = "es_AR.UTF-8";
		LC_TIME = "es_AR.UTF-8";
	};

	# powerManagement.powertop.enable = true;
	services.power-profiles-daemon.enable = false;
	services.thermald.enable = true;
	services.tlp = {
		enable = true;
		settings = {
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

			#CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;

			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;

			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 40;
		};
	};
	services.auto-cpufreq = { 
		enable = true; 
		settings = { 
			battery = {
          			governor = "powersave";
          			turbo = "never";
        		};
        		charger = {
          			governor = "powersave";
          			turbo = "auto";
        		};
      		};
	};
	services.flatpak.enable = true;
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users = {
		char2cs = {
			isNormalUser = true;
			description = "Mateo Urrutia";
			extraGroups = ["wheel" "networkmanager" "audio" "input" "libvirtd" "tss" "docker" "qemu-libvirtd" "dialout"];
			packages = with pkgs; [
				fish
			];
			shell = pkgs.fish;
		};
	};

	hardware.bluetooth.enable = true;

	virtualisation = {
		libvirtd.enable = true;
		docker.enable = true;
	};

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;

	services = {
		fwupd.enable = true;
		printing.enable = true;
		upower.enable = true;
		openssh.enable = true;
		xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			displayManager.gdm.wayland = true;
			displayManager.gdm.autoSuspend = false;
			desktopManager.gnome.enable = true;
			layout = "us";
			xkbVariant = "";
		};
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
		#openvpn.servers = {
		#	officeVPN = { 
		#		config = '' config /home/char2cs/Documents/vpn-fixear-tarano.ovpn '';
		#		updateResolvConf = true; 
		#	};
		#};
		teamviewer.enable = true;
	};

	programs.dconf.profiles.gdm.databases = [{
       		settings."org/gnome/settings-daemon/plugins/power" = {
         		power-button-action = "suspend";
         		sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        		sleep-inactive-battery-timeout = lib.gvariant.mkInt32 1;
       		};
     	}];

	programs = {
		thunar.enable = true;
		hyprland = {
			enable = true;
			xwayland.enable = true;
			# enableNvidiaPatches = true;
		};
		fish = {
			enable = true;
			interactiveShellInit = ''
				set fish_greeting # Disable greeting
			'';
		};
		firefox.enable = true;
		virt-manager.enable = true;
	};

	# Fonts!
	fonts.packages = with pkgs; [ fira-code ];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		htop
		neofetch
		pkgs.home-manager
		gnome.gnome-bluetooth_1_0
		gh
		git
		firefox
		tofi
		swaybg
		unzip
		neovim
		ripgrep
		pipewire
		wireplumber
		udiskie
		chromium
		efibootmgr
		floorp
		templ
		nix-output-monitor
		bottles
		lm_sensors
		dunst
		xdg-desktop-portal-hyprland
		brightnessctl
		kitty
    	fish
		bun
		polkit_gnome
		xdg-desktop-portal-wlr
		openssl
		openvpn
		teamviewer
		flatpak
	] ++ (with pkgs.unstable; [
		hypridle
		hyprlock
	]);
	
	system.stateVersion = "24.05";
}
