#!/bin/sh

# Set $VISUAL / $EDITOR
. ~/.shared_env

export MAIL_PROFILE_DIR=$HOME/mail/$MAIL_PROFILE
export MAIL_PROFILE_LOG=$MAIL_PROFILE_DIR/log

export MAIRIX_DIR=$MAIL_PROFILE_DIR/.mairix
export MAIRIXRC=$MAIRIX_DIR/config
export MAIRIX_RESULTS=$MAIL_PROFILE_DIR/mairix
export MAIRIX_VERSION=$( mairix --version | awk '{print $2}' )

export OFFLINEIMAP_CONF=$MAIL_PROFILE_DIR/.offlineimaprc
export OFFLINEIMAP_MAIL_DIR=$MAIL_PROFILE_DIR/offlineimap
export OFFLINEIMAP_STATE_DIR=$MAIL_PROFILE_DIR/.offlineimap
export OFFLINEIMAP_DEFAULT_ACCOUNT=$( grep '^accounts' $OFFLINEIMAP_CONF | awk '{print $3}' )
export OFFLINEIMAP_LOG_DIR=$MAIL_PROFILE_LOG/offlineimap/`date +%Y/%m`
export OFFLINEIMAP_LOG=$OFFLINEIMAP_LOG_DIR/`date +%d`
export OFFLINEIMAP_LOG_DEBUG=${OFFLINEIMAP_LOG}-debug
[ -d "$OFFLINEIMAP_LOG_DIR" ] || mkdir -p "$OFFLINEIMAP_LOG_DIR"
export OFFLINEIMAP_SLEEP_DURATION_FILE=$MAIL_PROFILE_DIR/.offlineimap-sleep.duration
export OFFLINEIMAP_SLEEP_PID_FILE=$MAIL_PROFILE_DIR/.offlineimap-sleep.pid


export MAIL_DAEMON_LOG=$MAIL_PROFILE_LOG/daemon.log
export MAIL_DAEMON_LOCK=$MAIL_PROFILE_DIR/.daemon.lock

export MSMTP_CONFIG=$MAIL_PROFILE_DIR/.msmtprc
