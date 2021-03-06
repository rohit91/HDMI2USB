#!/bin/bash
# vim: set ts=4 sw=4 et sts=4 ai:
#
# Copyright (c) 2014, Tim 'mithro' Ansell
# All rights reserved.
#
# Avaliable under MIT license - http://opensource.org/licenses/MIT
# See ../LICENSE file for full text.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/config.sh

set -e

if ! which travis > /dev/null; then
    echo "The travis tool is needed to upload the SSH key."
    echo "Please install it by follow the instructions at"
    echo " http://blog.travis-ci.com/2013-01-14-new-client/"
    exit 1
fi

if ! which ssh-keygen > /dev/null; then
    echo "The ssh-keygen tool to generate a SSH key."
    echo "Please install openssh-client."
    if [ -e /etc/lsb-release ]; then
        source /etc/lsb-release

        case $DISTRIB_ID in
            Ubuntu|Debian)
                echo "On Ubuntu and Debian systems run:"
                echo " sudo apt-get install openssh-client"
                ;;
        esac
    fi
    exit 1
fi

# Change to the script top level directory so travis commands work
cd $SCRIPT_DIR/..

# Get travis information for this repo
TRAVIS_USER="$(travis whoami --no-interactive)"
TRAVIS_USER_COLORFUL="$(travis whoami --interactive)"
TRAVIS_REPO="$(travis settings --no-interactive | head -1)"
TRAVIS_REPO_COLORFUL="$(script -q -c "travis env --interactive list" /dev/null | head -1 | sed -e's/#.* //')"

echo "$TRAVIS_USER_COLORFUL and setting keys for $TRAVIS_REPO_COLORFUL"
while true; do
    read -p "Is this correct? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo
if travis env list | grep -q "TRAVIS_SSHKEY_VALUE="; then
    echo "Travis already has a ssh key set, remove the old key before running."
    echo "You can do this by running the following command:"
    echo "$ travis env unset TRAVIS_SSHKEY_VALUE"
    exit 1
fi

exit 1

# Create the key if needed
if [ ! -e $TRAVIS_KEYFILE ];then
    export TRAVIS_SSHKEY_NAME="$TRAVIS_REPO@$(date +'%Y/%m/%d-%H:%M:%S')"
    ssh-keygen -b 2048 -t rsa -f $TRAVIS_KEYFILE -q -C "$TRAVIS_SSHKEY_NAME" -N ""
else
    export TRAVIS_SSHKEY_NAME="$(cat ${TRAVIS_KEYFILE}.pub | sed -e's/.* \([^ ]*\)/\1/')"
fi

# Upload key to travis
travis enable
travis env -P copy TRAVIS_SSHKEY_NAME
travis env -p set  TRAVIS_SSHKEY_VALUE "$(base64 -w0 $TRAVIS_KEYFILE)"

# Output pubkey part
echo
echo "Send the output below to mithro or shenki"
echo "========================================================================"
cat ${TRAVIS_KEYFILE}.pub
