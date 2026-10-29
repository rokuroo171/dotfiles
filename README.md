# dotfiles

Personal configuration files managed with a POSIX `/bin/sh` installer script.

## Directory Layout

* `core/` – Primary daily tools (`fish`, `mksh`, `nvim`, `kitty`, `fastfetch`, `starship.toml`)
* `specific/suckless/` – Custom C source header files (`config.h`) for `dwm` and `st`
* `install.sh` – the installation script

## Installation

Clone the repository and run the installer:

```sh
git clone [https://github.com/rokuroo171/dotfiles.git](https://github.com/rokuroo171/dotfiles.git) ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh

