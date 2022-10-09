if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "you are not a MacOS user, dang it."
    exit 130
fi

brew help > /dev/null
if [[ $? != 0 ]]; then
    # if there is no brew, install it
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    # there is brew, so update it
    brew update
fi

git --version > /dev/null
if [[ $? != 0 ]]; then
    # if there is no git, install it
    brew install git
fi


rustup --help > /dev/null
if [[ $? != 0 ]]; then
    # if there is no rustup, install it
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    # there is rustup, so update it
    rustup update
fi

brew install --cask font-hack-nerd-font warp && \
    brew install neovim zoxide

# if you are using zsh
if [ -n $zsh_version ]; then
    echo "eval \"\$(zoxide init zsh)\"" >> ~/.zshrc
# you are using bash
elif [ -n $bash_version ]; then
    echo "eval \"\$(zoxide init bash)\"" >> ~/.bashrc
else
    echo "failed to initialize zoxide, reason: unknown shell"
    exit 130
fi

lvim --help > /dev/null
if [[ $? != 0 ]]; then
    # if there is no lunarvim, install it
    LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh)
    _alias="alias vim=\"lvim\""
    # if you are using zsh
    if [ -n $zsh_version ]; then
        echo $_alias >> ~/.zshrc
    # you are using bash
    elif [ -n $bash_version ]; then
        echo $_alias >> ~/.bashrc
    else
        echo "failed to alias vim to lvim, reason: unknown shell"
        exit 130
    fi
fi

cd ~/.config

echo "mv ~/.config/lvim to ~/.config/lvim_prev"
mv ./lvim ./lvim_prev

echo "install just-do-halee lvim"
git clone https://github.com/just-do-halee/lvim.config lvim

echo "complete!"
lvim ./lvim

