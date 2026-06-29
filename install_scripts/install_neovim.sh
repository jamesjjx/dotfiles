#!/bin/bash
set -e
mkdir -p ~/.local/bin
rm -f ~/.local/bin/nvim
curl -Lo ~/.local/bin/nvim https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x ~/.local/bin/nvim
~/.local/bin/nvim +qall
