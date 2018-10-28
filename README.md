# mpv-scripts

My personal [mpv](https://mpv.io) scripts.

![mpv logo](https://raw.githubusercontent.com/mpv-player/mpv.io/master/source/images/mpv-logo-128.png)

pseudo-gif.lua
------
GIF-like behavior for files below the specified duration. An alternative to auto-profiles. Affected properties: `keep-open=yes`, `loop-file=inf`, `save-position-on-quit=no`.

This script can be customized through a config file placed in `script-opts/pseudo-gif.conf`.

toggle-pip.lua
------
Picture-in-picture toggle. **Requires [quick-scale.lua](https://github.com/VideoPlayerCode/mpv-tools)**.

This script can be customized through a config file placed in `script-opts/toggle-pip.conf`.

##### Usage

Set your own keybind in `input.conf` like `<key> script-message toggle_pip`.
