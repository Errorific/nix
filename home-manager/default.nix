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
  };
}

