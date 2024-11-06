{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("Iosevka Term NF"),
        font_size = 13.0;
        hide_tab_bar_if_only_one_tab = true
      }
    '';
  };
}
