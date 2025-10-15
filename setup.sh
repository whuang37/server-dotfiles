#!/bin/bash

WSL=false

if grep -qi microsoft /proc/version; then
    WSL=true
fi

touch ~/.bash_profile

# nvidia cuda driver install
# https://developer.nvidia.com/cuda-downloads?target_os=Linux
if command -v nvcc &>/dev/null; then
    echo "CUDA already installed:"
    nvcc --version
else
    if $WSL; then
        echo "Checking for existing CUDA installation..."
        echo "CUDA not found. Installing..."
        wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
        sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/13.0.1/local_installers/cuda-repo-wsl-ubuntu-13-0-local_13.0.1-1_amd64.deb
        sudo dpkg -i cuda-repo-wsl-ubuntu-13-0-local_13.0.1-1_amd64.deb
        sudo cp /var/cuda-repo-wsl-ubuntu-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda-toolkit-13-0
        rm cuda-repo-wsl-ubuntu-13-0-local_13.0.1-1_amd64.deb
        # setting up the git credential manager to connect to the main version as well
        git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
    else
        echo "NOT ON WSL UBUNTU. INSTALL CUDA MANUALLY."
    fi
    echo 'export PATH=/usr/lib/wsl/lib:$PATH' > ~/.bash_profile
    echo 'export PATH=/usr/local/cuda-13.0/bin:$PATH' > ~/.bash_profile
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH' > ~/.bash_profile
fi

# installing all the key programs
sudo apt install ffmpeg tmux htop fzf ncdu glances neofetch pv stow locales -y
sudo locale-gen en_US.UTF-8
curl -LsSf https://astral.sh/uv/install.sh | sh

# configuring all the dotfiles
echo "Symlinking dotfiles..."
cd config
for dir in */ ; do
    stow "$dir"
done
cd ..

# installing zsh
sudo apt install zsh -y
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search
# git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete # install to bare metal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
chsh -s $(which zsh)
echo "Shell changed to: $SHELL"


exec zsh
