#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/elliot/.nix-profile/etc/profile.d/nix.sh ]; then . /home/elliot/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
