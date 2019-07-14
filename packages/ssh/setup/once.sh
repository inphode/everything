#!/bin/bash

if ! [ -f "$HOME_PATH/.ssh/id_rsa" ]; then
    mkdir -p $HOME_PATH/.ssh
    echo "cp $SECURE_PATH/ssh/id_rsa $HOME_PATH/.ssh/id_rsa"
    cp $SECURE_PATH/ssh/id_rsa $HOME_PATH/.ssh/id_rsa
    chmod 400 $SECURE_PATH/ssh/id_rsa $HOME_PATH/.ssh/id_rsa
fi

if ! [ -f "$HOME_PATH/.ssh/id_rsa.pub" ]; then
    echo "cp $SECURE_PATH/ssh/id_rsa.pub $HOME_PATH/.ssh/id_rsa.pub"
    cp $SECURE_PATH/ssh/id_rsa.pub $HOME_PATH/.ssh/id_rsa.pub
    chmod 400 $SECURE_PATH/ssh/id_rsa.pub $HOME_PATH/.ssh/id_rsa.pub
fi

