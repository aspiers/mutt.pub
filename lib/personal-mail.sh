#!/bin/sh

export MAIL_PROFILE=personal
export MAIRIX_DIR=$HOME/.mairix/$MAIL_PROFILE
export MAIRIXRC=$MAIRIX_DIR/config
export MAIRIX_RESULTS=$HOME/mail/$MAIL_PROFILE/mairix
export MAIRIX_VERSION=$( mairix --version | awk '{print $2}' )
