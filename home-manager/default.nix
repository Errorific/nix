machineName:
{ config, pkgs, ... }:
let
  restart-taffybar = ''
    echo "Restarting taffybar..."
    $DRY_RUN_CMD rm -fr $HOME/.cache/taffybar/
    $DRY_RUN_CMD systemctl --user restart taffybar.service && true
    echo "Taffybar restart done"
  '';
in {
  nixpkgs.overlays = [
    (import ./home-overlays/taffybar)
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    dmenu
    networkmanagerapplet
    powertop
    

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

  home.file = {
    ".config/taffybar/taffybar.hs" = {
      source = ./dotfiles/taffybar/taffybar.hs;
      onChange = restart-taffybar;
    };
    # ".config/taffybar/taffybar.css" = {
    #   source = ./dotfiles/taffybar/taffybar.css;
    #   onChange = restart-taffybar;
    # };
  };

  services = { 
    taffybar.enable = true;
    xembed-sni-proxy.enable = true;
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.taffybar
      ];
      config = ./dotfiles/xmonad/xmonad.hs;
    };
  };
}
