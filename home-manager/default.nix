machineName:
{ config, pkgs, ... }:
let
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    neovim
    vim
    wget
    which
  ];

  programs = {
    home-manager.enable = true;    
    direnv.enable = true;
    chromium.enable = true;
    firefox.enable = true;
    htop.enable = true;
    git = {
      enable = true;
      userName = "Christopher Mckay";
      userEmail = "chris@error.cm";
      ignores = [];
    };
    urxvt = {
      enable = true;
      fonts = ["xft:Source Code Pro:size=11"];
    };
  };

  services = { 

  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
      ];
      config = ./dotfiles/xmonad/xmonad.hs;
    };
  };
}

