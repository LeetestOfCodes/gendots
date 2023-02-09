#!/bin/bash 

#Install XCode cmdline tools
xcode-select --install

#Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mkdir ~/RoamNotes

#Install fish
brew install fish

#change default shell to fish
chsh -s /opt/homebrew/bin/fish

# Install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

#fisher add fisher
fisher add jorgebucaran/fisher

# Install fish plugins
fisher add jethrokuan/z

# Install emacs
brew install emacs git lf python java maven kitty

# Install haskell language server
#brew install haskell-language-server

# Install nodejs
brew install node

# Install rust
brew install rust


# clone dotfiles
git clone https://github.com/LeetestOfCodes/gendots.git

mv ~/gendots/.config/fish/config.fish ~/.config/fish/config.fish

mv ~/gendots/init.el ~/.emacs.d/init.el

mv ~/gendots/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

mv ~/gendots/.config/lf/lfrc ~/.config/lf/lfrc

mv ~/gendots/skhdrc ~/.skhdrc

mv ~/gendots/yabairc ~/.yabairc


