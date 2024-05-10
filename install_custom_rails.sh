#!/bin/bash

# Get the current user's home directory
USER_HOME=$HOME

echo -e "\n"
echo "Which shell are you using?"
echo "1. Bash"
echo "2. Zsh"
read -p "Enter the number corresponding to your shell: " choice

case $choice in
    1)
        shell="bash"
        config_file="$USER_HOME/.bashrc"
        ;;
    2)
        shell="zsh"
        config_file="$USER_HOME/.zshrc"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo -e "\n"

# Install rbenv and ruby-build
# Check if ~/.rbenv directory exists
if [ -d "$USER_HOME/.rbenv" ]; then
    read -p "The directory '~/.rbenv' already exists. Do you want to remove it and reinstall? (y/n): " remove_rbenv
    if [[ $remove_rbenv == [yY] ]]; then
        rm -rf "$USER_HOME/.rbenv"
    else
        echo "Skipping rbenv installation."
        skip_rbenv=true
    fi
fi

# Check if ~/.rbenv/plugins/ruby-build directory exists
if [ -d "$USER_HOME/.rbenv/plugins/ruby-build" ]; then
    read -p "The directory '~/.rbenv/plugins/ruby-build' already exists. Do you want to remove it and reinstall? (y/n): " remove_ruby_build
    if [[ $remove_ruby_build == [yY] ]]; then
        rm -rf "$USER_HOME/.rbenv/plugins/ruby-build"
    else
        echo "Skipping ruby-build installation."
        skip_ruby_build=true
    fi
fi

# Install rbenv and ruby-build if not skipped
if [[ ! $skip_rbenv ]]; then
    sudo apt update
    sudo apt install wget curl git build-essential -y
    git clone https://github.com/rbenv/rbenv.git "$USER_HOME/.rbenv"
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$config_file"
    echo 'eval "$(rbenv init -)"' >> "$config_file"
fi

if [[ ! $skip_ruby_build ]]; then
    git clone https://github.com/rbenv/ruby-build.git "$USER_HOME/.rbenv/plugins/ruby-build"
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> "$config_file"
fi

source "$config_file"

# Install Ruby
if [[ -z $install_ruby ]]; then
    install_ruby="n"
fi
if [[ $install_ruby == [yY] ]]; then
    read -p "Enter the version of Ruby you want to install (default: 2.4.5): " ruby_version
    ruby_version=${ruby_version:-2.4.5}
    rbenv install "$ruby_version"
    rbenv global "$ruby_version"
    echo -e "Ruby $(ruby -v) installed successfully!\n"
fi

# Install Bundler
if [[ -z $install_bundler ]]; then
    install_bundler="n"
fi
if [[ $install_bundler == [yY] ]]; then
    read -p "Enter the version of Bundler you want to install (default: 1.17.3): " bundler_version
    bundler_version=${bundler_version:-1.17.3}
    gem install bundler -v "$bundler_version"
    echo -e "Bundler $(bundler -v) installed successfully!\n"
fi

# Install Rails
if [[ -z $install_rails ]]; then
    install_rails="n"
fi
if [[ $install_rails == [yY] ]]; then
    read -p "Enter the version of Rails you want to install (default: 4.0.5): " rails_version
    rails_version=${rails_version:-4.0.5}
    gem install rails -v "$rails_version"
    echo -e "Rails $(rails -v) installed successfully!\n"
fi

echo "gem: --no-document" > "$USER_HOME/.gemrc"
echo -e "Script execution completed.\n"
