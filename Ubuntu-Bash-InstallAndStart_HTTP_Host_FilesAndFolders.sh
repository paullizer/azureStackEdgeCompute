# Run as Root
    sudo su root;

# install BlobFuse
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb;
    sudo dpkg -i packages-microsoft-prod.deb;
    sudo apt-get update -y;
    sudo apt-get install  -y blobfuse;


# create Fuse Connection
    touch fuse_connection.cfg;
    echo accountName REPLACE_WITH_STORAGE_ACCOUNT_NAME >> fuse_connection.cfg
    # Use Key 1
    echo accountKey REPLACE_WITH_STORAGE_ACCOUNT_KEY >> fuse_connection.cfg
    echo containerName REPLACE_WITH_CONTAINER_NAME >> fuse_connection.cfg
    chmod 600 fuse_connection.cfg;


# mount BlobFuse
    mkdir ~/uniqueName;
    blobfuse ~/uniqueName --tmp-path=/mnt/resource/blobfusetmp  --config-file=fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120;
    cd ~/uniqueName;
    ls;


# install Curl
    sudo apt install  -y curl;
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -;
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list;


# install OS Prerequisites
    sudo apt-get update -y;
    sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn;


# clone Rbenv
    cd;
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv;
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc;
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc;
    exec $SHELL;


# clone Ruby
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build;
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc;
    exec $SHELL;


# install Ruby
    rbenv install 3.1.2;


# Activate Ruby
    rbenv global 3.1.2;
    ruby -v;


# install Bundler
    gem install bundler;


# install Rails
    gem install rails -v 7.0.2.4;


# install  WEBrick
    gem install webrick;


# Rehash Rbenv
    rbenv rehash;
    rails -v;


# create Rails Site
    rails new uniqueNameWebHost;


# Create Script to enforce ruby web host is running, if it is not running - start the ruby web host
    touch ~/enforceWebHostServerRun.sh;
    echo '#!/bin/bash' > ~/enforceWebHostServerRun.sh;
    echo 'webHostServerIpAddress=127.0.0.1;' >> ~/enforceWebHostServerRun.sh;
    echo 'webHostServerPort=8080;' >> enforceWebHostServerRun.sh;
    echo 'webHostStatus=$(curl -Is http://$webHostServerIpAddress:$webHostServerPort | head -1);' >> ~/enforceWebHostServerRun.sh;
    echo 'if [[ "$webHostStatus" != *"200 OK"* ]]; then' >> ~/enforceWebHostServerRun.sh;
    echo '  echo "Ruby Web Server is NOT running.";' >> ~/enforceWebHostServerRun.sh;
    echo '  echo "Starting Web Server.";' >> ~/enforceWebHostServerRun.sh;
    echo '  sudo su root;' >> ~/enforceWebHostServerRun.sh;
    echo '  cd ~/uniqueName;'>> ~/enforceWebHostServerRun.sh;
    echo '  /root/.rbenv/shims/ruby -r un.rb -e httpd . -p 8080 > ~/webHostServerStatus.out;' >> ~/enforceWebHostServerRun.sh;
    echo '  echo "Started Web Server."' >> ~/enforceWebHostServerRun.sh;
    echo 'else' >> ~/enforceWebHostServerRun.sh;
    echo '  echo "Ruby Web Server is running."' >> ~/enforceWebHostServerRun.sh;
    echo 'fi' >> ~/enforceWebHostServerRun.sh;
    chmod +x ~/enforceWebHostServerRun.sh;

# Create user cron job to run script every two minutes
    nano /etc/crontab
    # Select Option 1 to use Nano text editor
    # Copy the following and paste it into the Nano editor
    */2 *   * * *   root    /root/enforceWebHostServerRun.sh
    # ctrl+s to save
    # ctrl+x to exit