{pkgs, lib, ...}:
let
  mwEmacs = (pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-git;
      config = "/home/midwit/.emacs.d/init.el";
      extraEmacsPackages = epkgs: [
        epkgs.pdf-tools
        epkgs.mu4e
        epkgs.treesit-grammars.with-all-grammars
        epkgs.exwm
        epkgs.vterm
        pkgs.emacs-all-the-icons-fonts
        pkgs.emacs-lsp-booster
      ];
    });
in {
  services.emacs = {
    # enable = true;
    # Not sure about this
    # startWithUserSession = true;

    # Whether to enable generation of Emacs client desktop file.
    package = mwEmacs;
    client.enable = true;
  };

  home.packages = [
    pkgs.emacs-lsp-booster
    pkgs.sqlfluff
    # proxy for matrix
    pkgs.python3Full
    pkgs.gtk3
    pkgs.pkg-config
    pkgs.glibc
    pkgs.glib
    pkgs.gobject-introspection
    pkgs.python3Packages.pygobject3
    pkgs.python3Packages.dbus-python
    pkgs.cairo
    pkgs.python3Packages.pycairo
  ];

  # Register org-protocol handler
  # run `nix-shell -p desktop-file-utils --run "update-desktop-database .local/share/applications/"`
  # to update desktop database
  home.file.".local/share/applications/emacs-capture.desktop" = {
    text = ''
        [Desktop Entry]
        Name=Org Capture
        Exec=${mwEmacs}/bin/emacsclient %u
        Comment=org-protocol capture
        Icon=${mwEmacs}/share/icons/hicolor/scalable/apps/emacs.svg
        Type=Application
        Terminal=false
        MimeType=x-scheme-handler/org-protocol;
    '';
  };

  home.file.".local/bin/scripts/pomodoro-bar.sh" = {
    text = ''
      #!/bin/sh

      pomo_message=$(${pkgs.emacs}/bin/emacsclient -e '(mw/org-pomodoro-time)' | ${pkgs.coreutils}/bin/cut -d '"' -f 2)
      echo ''${pomo_message}
    '';
    executable = true;
  };

  programs.emacs = {
    enable = true;
    package = mwEmacs;
    extraPackages = epkgs: [
      pkgs.ffmpeg
      epkgs.mu4e
      epkgs.lspce
      pkgs.keychain
      pkgs.emacs-lsp-booster
    ];
  };
}
