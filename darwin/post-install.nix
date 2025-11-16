{ config, pkgs, ... }:

{
  system.defaults = {
    # Dock
    CustomUserPreferences = {
      "com.apple.dock" = {
        expose-group-apps = true;
      };
    };

    # Add more defaults here as needed, e.g.:
    # dock = {
    #   autohide = true;
    #   show-recents = false;
    # };
    # finder = {
    #   ShowPathbar = true;
    #   ShowStatusBar = true;
    # };
  };
}
