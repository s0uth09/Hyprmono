hl.env("qsConfig", "ii")

terminal = "~/.local/bin/launch_first_available.sh 'foot' 'kitty -1' 'alacritty' 'wezterm' 'konsole' 'kgx' 'uxterm' 'xterm'"
fileManager = "~/.local/bin/launch_first_available.sh 'nautilus' 'nemo' 'thunar' 'kitty -1 fish -c yazi'"
browser = "~/.local/bin/launch_first_available.sh 'google-chrome-stable' 'zen-browser' 'firefox' 'brave' 'chromium' 'microsoft-edge-stable' 'opera' 'librewolf'"
codeEditor = "~/.local/bin/launch_first_available.sh 'windsurf' 'antigravity' 'code' 'codium' 'cursor' 'zed' 'zedit' 'zeditor' 'kate' 'gnome-text-editor' 'emacs' 'command -v nvim && kitty -1 nvim' 'command -v micro && kitty -1 micro'"
officeSoftware = "~/.local/bin/launch_first_available.sh 'wps' 'onlyoffice-desktopeditors' 'libreoffice'"
textEditor = "~/.local/bin/launch_first_available.sh 'kate' 'gnome-text-editor' 'emacs'"
volumeMixer = "~/.local/bin/launch_first_available.sh 'pavucontrol-qt' 'pavucontrol'"
settingsApp = "XDG_CURRENT_DESKTOP=gnome ~/.local/bin/launch_first_available.sh 'qs -p ~/.config/quickshell/$qsConfig/settings.qml' 'systemsettings' 'gnome-control-center' 'better-control'"
taskManager = "~/.local/bin/launch_first_available.sh 'gnome-system-monitor' 'plasma-systemmonitor --page-name Processes' 'command -v btop && kitty -1 fish -c btop'"
local menu = "wofi --show drun"

workspaceGroupSize = 10