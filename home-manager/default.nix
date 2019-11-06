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
    blueman
    

    neovim
    vim
    vscode
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
    tmux = {
      enable = true;
      historyLimit = 10000;
      terminal = "screen-256color";
      aggressiveResize = true;
      shortcut = "z";
    };
    urxvt = {
      enable = true;
      fonts = ["xft:Sauce Code Pro:size=11"];
      #fonts = ["xft:terminus:size=11"];
    };
    #vscode = {
    #  enable = true;
    #};
    zsh = {
      enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
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
    status-notifier-watcher.enable = true;
    network-manager-applet.enable = true;
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

  xresources.extraConfig = ''
  ! special
  *.foreground:   #c5c8c6
  *.background:   #000000
  *.cursorColor:  #c5c8c6
  ! black
  *.color0:       #282a2e
  *.color8:       #373b41
  ! red
  *.color1:       #a54242
  *.color9:       #cc6666
  ! green
  *.color2:       #8c9440
  *.color10:      #b5bd68
  ! yellow
  *.color3:       #de935f
  *.color11:      #f0c674
  ! blue
  *.color4:       #5f819d
  *.color12:      #81a2be
  ! magenta
  *.color5:       #85678f
  *.color13:      #b294bb
  ! cyan
  *.color6:       #5e8d87
  *.color14:      #8abeb7
  ! white
  *.color7:       #707880
  *.color15:      #c5c8c6
  '';
}
