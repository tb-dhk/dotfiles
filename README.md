# shua's config files

this is a collection of my config files for various programs. these files are designed for swaywm and waybar on linux mint. these are my personal config files, so there is no guarantee that they will work on other systems.

this configuration is heavily inspired by the [constructed language](https://conlang.org) [toki pona](https://tokipona.org) and its logographic writing system, [sitelen pona](https://sona.pona.la/wiki/sitelen_pona).

i use linux mint and the colorscheme used here is [catppuccin](https://github.com/catppuccin/catppuccin).

## features
- swaywm
    - new workspaces
        - `mod` + `Ctrl` + number to switch to workspaces 11 to 20
        - `mod` + `Ctrl` + `Shift` + number to move the current window to workspaces 11 to 20
    - screenshotting
        - `Print` to take a screenshot of the entire screen (already in default config)
        - `mod` + `Print` to take a screenshot of the current window
        - `Shift` + `Print` to take a screenshot of the current workspace
        - add `Ctrl` to any of the above to save the screenshot to the clipboard
- waybar
    - top bar
        - workspace numbers in sitelen pona (up to 20)
        - "shua's computer" in sitelen pona
        - notifications
    - bottom bar
        - left
            - currently playing media
            - active steam games
        - center
            - currently focused window
        - right
            - cpu temperature
            - volume
            - backlight brightness
            - battery
            - date and time

![sample image containing features described above](./sample.png)

## requirements
- swaywm
- waybar
- fairfax hd and fairfax pona hd (fonts)

## important commands
```
# cbonsai 
cbonsai -L 50 -c "󱤗"

# neofetch
neofetch --ascii ~/.config/neofetch/tokipona.txt --ascii_colors 4 3

# unimatrix
unimatrix -u "$(~/.config/scripts/sitelen-pona.sh)"

# tty-clock
tty-clock -s -c -C 3

# pipes.sh
pipes.sh -f 100 -r 0
```
