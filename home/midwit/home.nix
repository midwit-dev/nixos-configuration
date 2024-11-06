{ inputs, config, pkgs, lib, ... }:

{  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "midwit";
  home.homeDirectory = "/home/midwit";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # system ops
    htop
    btop
    tree
    ripgrep
    fd
    procps
    killall

    pinentry-curses
    keychain

    # email
    protonmail-bridge
    mu
    isync
    meson

    libnotify

    # Development
    gnumake
    eask # for developing emacs packages
    entr
    # inputs.devenv.packages."${system}".devenv
    cachix
    scc

    pandoc

    # Utilities
    flameshot # screenshots
    graphviz
    sound-theme-freedesktop
    # Draw UML diagrams using a simple and human readable text description
    plantuml
    unzip

    gimp

    # Communication
    discord
    slack

    # for ffmpeg x11grab
    xorg.libxcb

    # To be offered a list of "Installed applications" when opening a file.
    lxmenu-data
    # To recognise different file types.
    shared-mime-info
  ];


  services.blueman-applet = {
    enable = true;
  };

  services.poweralertd.enable = true;

  services.ssh-agent = {
    enable = true;
  };

  services.git-sync = {
    enable = true;
    repositories = {
      org-files = {
        path = "/home/midwit/org";
        uri = "git@github.com:midwit-dev/org.git";
      };
    };
  };

  services.syncthing = {
    enable = true;
    extraOptions = [];
 };

  # home.file.".config/dunst/glove80" = {
  #   text = ''
  #     appname=$1
  #     summary=$2
  #     body=$3
  #     icon_path=$4
  #     urgency=$5

  #     battery_pct=$(echo $1 | sed -r 's/Connected ([0-9+])%/\1/')
  #   '';
  # };

  services.dunst = {
    enable = true;
    settings = {
      "skip-rule" = {
        appname = "blueman";
        summary = "Glove80";
        skip_delay = true;
      };
      global = {
        # follow = "keyboard";
      };
    };
  };

  services.redshift = {
    enable = true;
    tray = true;

    # Oslo
    latitude = 59.9139;
    longitude = 10.7522;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
			Requires = [ "graphical-session-pre.target" ];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # GOPATH = "$HOME/go";
  };
  # home.sessionPath = [ "$HOME/go/bin" ];

  # nixpkgs.config.allowUnfree = true;

  # https://github.com/nix-community/home-manager/issues/2942
  # nixpkgs.config.allowUnfreePredicate = (_: true);

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

 programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

  programs.kitty = {
    enable = false;
    theme = "Tokyo Night";
    font = {
      name = "JetBrainsMono NF";
      size = 11;
    };
    extraConfig = ''
      cursor_blink_interval 0
      background_opacity 0.9
      background #0d0e1c
    '';
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "emacs";
    mouse = false;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-b";
    # no delay when pressing <Esc>
    escapeTime = 0;
    extraConfig = ''
      set -g status-bg black
      set -g status-fg white
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.rofi = {
    enable = true;
    theme = "DarkBlue";
  };

  programs.password-store = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "The Midwit Developer";
    userEmail = "yo@midwit.dev";
    extraConfig = {
      github.userName = "midwit-dev";
    };
  };
}
