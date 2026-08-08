{ config, pkgs, ... }:
let
  waybar = pkgs.stdenvNoCC.mkDerivation {
    name = "waybar-config";

    src = ../dots/archlinux/.config/waybar;

    nativeBuildInputs = [
      pkgs.dart-sass
    ];

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      sed -i 's/󰣇/󱄅/g' $out/config.jsonc
      sass style.scss $out/style.css

      rm $out/style.scss
    '';
  };
  breezeGtk = import ./packages/breeze-gtk.nix { inherit pkgs; };
  monochromeIcons = pkgs.stdenv.mkDerivation {
    pname = "yet-another-monochrome-icon-set";
    version = "git";

    src = pkgs.fetchgit {
      url = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git";
      rev = "c5c3efe961e843b865d2b13b8180aff6ce64e496";
      hash = "sha256-1UrfH4AH2+tlFgc13X1nacaBzbucPeF8N/1m9gDDf30=";
    };

    installPhase = ''
      mkdir -p $out/share/icons/yet-another-monochrome-icon-set
      cp -r ./* $out/share/icons/yet-another-monochrome-icon-set/
    '';
  };
in
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    gcr
    polkit_gnome
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    thunar
    tumbler
    awww
    wofi
    wl-clipboard
    grim
    slurp
    playerctl
    pavucontrol
    dart-sass
    firefox
    alacritty
    jq
    dunst
    htop
    dconf
    xdg-utils
    kdePackages.breeze-icons
    discord
    zed-editor
  ];
  programs.waybar.enable = true;
  programs.git = {
    enable = true;
    settings.user.name = "Animesh Murmu";
    settings.user.email = "am2646374@gmail.com";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraLuaFiles = {
      "main.lua" = ../dots/archlinux/.config/hypr/hyprland.lua;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = breezeGtk;
      name = "Breeze-Dark";
    };
    iconTheme = {
      package = monochromeIcons;
      name = "yet-another-monochrome-icon-set";
    };
  };
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 20;
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "gtk3";
  };
  xdg.enable = true;
  xdg.configFile."hypr/bin".source = ../dots/archlinux/.config/hypr/bin;
  xdg.configFile."alacritty".source = ../dots/archlinux/.config/alacritty;
  xdg.configFile."nvim".source = ../dots/archlinux/.config/nvim;
  xdg.configFile."wofi".source = ../dots/archlinux/.config/wofi;
  xdg.configFile."dunstrc".source = ../dots/archlinux/.config/dunstrc;
  xdg.configFile."Thunar".source = ../dots/archlinux/.config/Thunar;
  xdg.configFile."zed".source = ../dots/archlinux/.config/zed;
  xdg.configFile."waybar".source = waybar;
  home.file."${config.xdg.userDirs.pictures}/Screenshots/.keep".text = "";

  services.gnome-keyring.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
