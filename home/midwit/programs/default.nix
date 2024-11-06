{ pkgs, ... }:

{
  imports = [
    ./foot.nix
    ./emacs.nix
    ./fzf.nix
    ./media.nix
    ./wezterm.nix
  ];

  home.packages = with pkgs; [
    pcmanfm
    qbittorrent
    killall

    jdk21
    lua-language-server

    bitwig-studio5
  ];
}
