# Run as Root
    sudo su root


# install BlobFuse
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update -y 
    sudo apt-get install  -y blobfuse


# create Fuse Connection
    touch fuse_connection.cfg
    echo accountName REPLACE_WITH_STORAGE_ACCOUNT_NAME >> fuse_connection.cfg
    # Use Key 1
    echo accountKey REPLACE_WITH_STORAGE_ACCOUNT_KEY >> fuse_connection.cfg
    echo containerName REPLACE_WITH_CONTAINER_NAME >> fuse_connection.cfg
    chmod 600 fuse_connection.cfg


# mount BlobFuse
    mkdir ~/uniqueName
    blobfuse ~/uniqueName --tmp-path=/mnt/resource/blobfusetmp  --config-file=fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
    cd ~/uniqueName
    ls


# install Curl
    sudo apt install  -y curl
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list


# install OS Prerequisites
    sudo apt-get update -y 
    sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn


# clone Rbenv
    cd
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL


# clone Ruby
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL


# install Ruby
    rbenv install 3.1.2


# Activate Ruby
    rbenv global 3.1.2
    ruby -v


# install Bundler
    gem install bundler


# install Rails
    gem install rails -v 7.0.2.4


# install  WEBrick
    gem install webrick


# Rehash Rbenv
    rbenv rehash
    rails -v


# create Rails Site
    rails new uniqueNameWebHost


# run Ruby Web Host
    sudo su root
    cd ~/uniqueName
    ruby -run -ehttpd . -p8080

