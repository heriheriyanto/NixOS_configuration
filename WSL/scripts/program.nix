# private needed program

{ config, lib, pkgs, ... }:

{
	
  #activate gnome-desktop	
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  
  security.pki.certificates = [
  (builtins.readFile /mnt/d/zscaler.cer)
	];
  
  #security.pki.certificateFiles = [ "/mnt/d/zscaler.cer" ];  
  #nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";
  xdg.portal = {
  	enable = true;
  	# Backend portal untuk window manager Wayland berbasis wlroots (seperti labwc / Sway)
  	wlr.enable = true;
  	# Backend tambahan untuk menangani dialog file GTK (Save/Open file) & tema
  	extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  	# Wajib di NixOS versi baru agar portal tahu backend mana yang dipakai
  	config.common.default = "*";
	};

  nixpkgs.config.allowUnfree = true; 

  services.flatpak.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.git.enable = true;
  programs.nix-ld = {
  	enable = true;

  	libraries = with pkgs; [
    		stdenv.cc.cc
    		zlib
  		];
	};  
  
  programs.bash = {
  	enable = true;
  	shellAliases = {
    		ll = "ls -la";
    	 	tree = "tree -L 2";
			nrs = "sudo nixos-rebuild switch";
			gnome = "dbus-run-session -- gnome-shell --devkit --wayland --no-x11";
  	 };
	};
  
  environment.systemPackages = with pkgs; [
	gnome-tweaks
	celluloid
  	geany
	nautilus
	fastfetch
	tree
	curl
	wget
	python313
	python313Packages.pip
	python313Packages.python-dotenv
  	
	# paket lain...

	(pkgs.writeShellScriptBin "pythonld" ''
    		export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    		exec -a "$0" ${pkgs.python313}/bin/python "$@"
  	'')
	
	];


}
