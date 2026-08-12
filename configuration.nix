# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.systemd-boot.xbootldrMountPoint = "/boot";
  hardware.graphics.enable = true;

  networking.hostName = "nixos";

  # Configure network connections interactively with nmcli or nmtui.
  systemd.network.enable = true;
  networking.wireless.iwd.enable = true;
  networking.useDHCP = false;
  systemd.network.networks."10-wired" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
    linkConfig.RequiredForOnline = "no";
  };
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = true;
  services.timesyncd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    wget
    git
    virt-manager
    docker-buildx
    docker-compose
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.dconf.enable = true;


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xfce.enable = true;
  #     xterm.enable = false;
  #   };
  # };
  # services.displayManager.defaultSession = "xfce";

  virtualisation.libvirtd.enable = true;
  systemd.services.libvirtd.enable = false;
  systemd.sockets.libvirtd.enable = false;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  systemd.services.docker.enable = false;
  systemd.user.services.docker.enable = false;

  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
