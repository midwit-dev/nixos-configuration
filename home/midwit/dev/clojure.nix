{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clojure
    clojure-lsp
    clj-kondo
  ];

  home.file.".config/clj-kondo/config.edn".text = ''
    {:linters {:unused-value {:level :warning}}}
  '';
}
