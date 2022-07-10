#!/bin/bash

USER=$USER


function usage () {
    echo "Usage:"
    echo "./expose.sh install: Install composer and expose"
    echo "sudo ./expose.sh configure <subdomaine> <token>: configure subdomain and credentials"
    echo "sudo ./expose.sh start : start expose"
    echo "sudo ./expose.sh stop: stop expose"
    exit 1
}

function check_install () {
    # check if composer is installed
    if [ ! -f /usr/bin/composer ]; then
        echo "Composer is not installed. Please install composer first."
        usage
        exit 1
    fi
    # check if expose is installed
    if ! foobar_loc="$(type -p "expose")"; then
        echo "expose is not installed. Please install expose first."
        usage
        exit 1
    fi
}

function install_expose () {
    #check if composer is installed
    if [ ! -f /usr/bin/composer ]; then
        echo "Installing composer"
        sudo apt install composer
    fi

    # check if expose is installed
    if [ ! -f $HOME/.config/composer/vendor/bin/expose ]; then
        echo "Installing expose"
        composer global require beyondcode/expose
    fi

    if ! foobar_loc="$(type -p "expose")"; then
    # add expose to /usb/local/bin
    echo "Add expose to path"
    sudo -u $USER cp $HOME/.config/composer/vendor/bin/expose /usr/local/bin/expose
    fi
}


# Create new systemd service
function install_service () {
    check_install
    echo "Creating new systemd service"
    SUBDOMAIN=$1
    TOKEN=$2
# Init service file
sudo cat > /etc/systemd/system/expose-lnbits.service << EOF
[Unit]
Description=Expose
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/expose share http://localhost:3007 --subdomain=$SUBDOMAIN --domain=exp.openchain.fr --server=exp.openchain.fr --server-host=exp.openchain.fr  --server-port=443  --auth=$TOKEN
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# Enable new systemd service
echo "Enabling new systemd service"
sudo systemctl enable expose-lnbits.service

# Start new systemd service
echo "Starting new systemd service"
service expose-lnbits start
check_service_started

}

function start_expose () {
    echo "Starting expose"
    check_service_started
}
function stop_expose () {
    echo "Stopping expose"
    sudo service expose-lnbits stop
}

# Usage
if [ -z $1 ] || [ $1 = "help" ]; then
usage
fi

# Install expose
if [ $1 = "install" ]; then
    install_expose
fi

function check_service_started () {
    # check if systemd service is started
    STATUS="$(systemctl is-active --quiet expose-lnbits && echo Service is running)"
    if [ "$STATUS" = "Service is running" ]; then
        echo "Service is running"
        sudo service expose-lnbits restart
        sleep 5
        FILTER="$(systemctl status expose-lnbits | grep https)"
        # if filter is empty, service is not started
        if [ -z "$FILTER" ]; then
            echo "FAILURE : Your application was not published. run the following command and open an issue on https://github.com/johnongit/expose-lnbits-script/issues"
            echo "sudo service expose-lnbits start"
        else
            echo "Your application is available at"
            echo $FILTER
        fi
        
        exit 1
    fi
}

# Configure expose service
if [ $1 = "configure" ]; then
    check_install
    # Check if subdomain and token are set
    if [ -z $2 ] || [ -z $3 ]; then
    # not set, return usage
        usage
    else
    # call install_expose function
    install_service $2 $3
    fi
fi

# Call start function
if [ $1 = "start" ]; then
    check_install
    start_expose
fi

# Call stop function
if [ $1 = "stop" ]; then
    check_install
    stop_expose
fi