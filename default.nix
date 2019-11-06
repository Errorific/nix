machineName:
{ config, pkgs, ... }:
let 
  thisPath = ./.;
  home-manager-src = import "${thisPath}/deps/home-manager";
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      "${thisPath}/machine.${machineName}.nix"
      "${home-manager-src}/nixos"
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://cachix.cachix.org"
      "https://all-hies.cachix.org"
      "https://nixcache.reflex-frp.org"
      "https://hydra.qfpl.io"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
    ];
    trustedUsers = [ "root" "chris" ];
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
    };
    hostName = "${machineName}";
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      daemon.config = {
        flat-volumes = "no";
      };
    };
    bluetooth = {
      enable = true;
    };
    brightnessctl.enable = true;
  };

  sound.enable = true;

  time.timeZone = "Australia/Brisbane";

    # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      noto-fonts-emoji
      emojione
      (nerdfonts.override {withFont = "SourceCodePro";})
      (nerdfonts.override {withFont = "Terminus";})
      (nerdfonts.override {withFont = "FiraCode";})
      (nerdfonts.override {withFont = "AnonymousPro";})
      # terminus_font # for hidpi screens, large fonts
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  programs = {
    bash.enableCompletion = true;
    ssh.startAgent = true;
  };

  virtualisation = {
    virtualbox = {
      host.enable = true;
      host.enableExtensionPack = true;
    };
    docker = {
      enable = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    upower.enable = true;
    printing.enable = true;
    xserver = {
      dpi = 120;
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      xkbOptions = "ctrl:nocaps";
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
    };
    fwupd = {
      enable = true;
    };
  };

  powerManagement.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  home-manager.users.chris = import ./home-manager "${machineName}";
  users.extraUsers.chris = {
    createHome = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
    home = "/home/chris";
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment? 
}
