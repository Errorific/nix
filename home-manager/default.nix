machineName:
{ config, pkgs, ... }:
let
  restart-taffybar = ''
    echo "Restarting taffybar..."
    $DRY_RUN_CMD rm -fr $HOME/.cache/taffybar/
    $DRY_RUN_CMD systemctl --user restart taffybar.service && true
    echo "Taffybar restart done"
  '';

  startupItem = {cmd, description}:
    {
      Unit = {
        Description = "${description}";
      };

      Service = {
        ExecStart = "${cmd}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in {
  nixpkgs.overlays = [
    (import ./home-overlays/taffybar)
    (import ./home-overlays/tmux-themepack)
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      dmenu
      networkmanagerapplet
      powertop
      
      slack

      sidequest
      google-drive-ocamlfuse
      s-tui
      stress

      neovim
      vim
      vscode
      wget
      which
      # Install stable HIE for GHC 8.6.5 and 8.4.4
      (all-hies.selection { selector = p: { inherit (p) ghc865 ghc844; }; })
    ];
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "chromium";
    };
  };

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
      extraConfig = ''
        source-file "${pkgs.tmux-themepack}/powerline/block/gray.tmuxtheme"
      '';
    };
    urxvt = {
      enable = true;
      #fonts = ["xft:Sauce Code Pro Nerd Font:size=11"];
      #fonts = ["xft:TerminessTTF Nerd Font:size=11"];
      fonts = ["xft:FuraCode Nerd Font:size=11"];
      transparent = true;
      shading = 20;
      extraConfig = {
        "antialias" = true;
        "depth" = 32;
        "background" = "rgba:0000/0000/0000/cccc";
      };
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "extract"
          "history"
          "git"
          "git-extras"
          "tmux"
          "ssh-agent"
        ];
      };
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
    blueman-applet.enable = true;
    flameshot.enable = true;
    unclutter.enable = true;
    dunst = {
      enable = true;
      settings = {
        global = {
          font = "Source Code Pro";
          markup = "full";
          format = "<b>%s</b>\\n%b";
          icon_position = "left";
          sort = true;
          alignment = "center";
          geometry = "500x60-15+49";
          browser = "/usr/bin/firefox -new-tab";
          transparency = 10;
          word_wrap = true;
          show_indicators = false;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          separator_color = "frame";
          frame_width = 2;
        };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };
        urgency_low = {
          frame_color = "#3B7C87";
          foreground = "#3B7C87";
          background = "#191311";
          timeout = 4;
        };
        urgency_normal = {
          frame_color = "#5B8234";
          foreground = "#5B8234";
          background = "#191311";
          timeout = 6;
        };
        urgency_critical = {
          frame_color = "#B7472A";
          foreground = "#B7472A";
          background = "#191311";
          timeout = 8;
        };
      };
    };
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
