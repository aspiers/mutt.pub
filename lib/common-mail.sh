#!/bin/sh

# Set $VISUAL / $EDITOR
. ~/.shared_env

export MAIL_PROFILE_DIR=$HOME/mail/$MAIL_PROFILE
export MAIL_PROFILE_LOG=$MAIL_PROFILE_DIR/log

export MAIRIX_DIR=$MAIL_PROFILE_DIR/.mairix
export MAIRIXRC=$MAIRIX_DIR/config
export MAIRIX_RESULTS=$MAIL_PROFILE_DIR/mairix

export NOTMUCH_DIR=$MAIL_PROFILE_DIR/notmuch
# N.B. config file has to be outside directory, at least for bootstrapping
export NOTMUCH_CONFIG=$MAIL_PROFILE_DIR/.notmuch-config
export NOTMUCH_RESULTS=$NOTMUCH_DIR/results

if which mairix >/dev/null 2>&1; then
    export MAIRIX_VERSION=$( mairix --version | awk '{print $2}' )
else
    echo "Warning: mairix not found on \$PATH" >&2
    export MAIRIX_VERSION=not-found
fi

if which notmuch >/dev/null 2>&1; then
    export NOTMUCH_VERSION=$( notmuch --version | awk '{print $2}' )
else
    echo "Warning: notmuch not found on \$PATH" >&2
    export NOTMUCH_VERSION=not-found
fi
fi

export OFFLINEIMAP_CONF=$MAIL_PROFILE_DIR/.offlineimaprc
export OFFLINEIMAP_MAIL_DIR=$MAIL_PROFILE_DIR/offlineimap
export OFFLINEIMAP_INBOX=$OFFLINEIMAP_MAIL_DIR/INBOX
export OFFLINEIMAP_STATE_DIR=$MAIL_PROFILE_DIR/.offlineimap

if [ -e $OFFLINEIMAP_CONF ]; then
    export OFFLINEIMAP_DEFAULT_ACCOUNT=$( grep '^accounts' $OFFLINEIMAP_CONF | awk '{print $3}' )
fi

export OFFLINEIMAP_LOG_DIR=$MAIL_PROFILE_LOG/offlineimap/`date +%Y/%m`
export OFFLINEIMAP_LOG=$OFFLINEIMAP_LOG_DIR/`date +%d`
export OFFLINEIMAP_DEBUG_LOG=${OFFLINEIMAP_LOG}-debug
[ -d "$OFFLINEIMAP_LOG_DIR" ] || mkdir -p "$OFFLINEIMAP_LOG_DIR"
export OFFLINEIMAP_SLEEP_DURATION_FILE=$MAIL_PROFILE_DIR/.offlineimap-sleep.duration
export OFFLINEIMAP_SLEEP_PID_FILE=$MAIL_PROFILE_DIR/.offlineimap-sleep.pid
export OFFLINEIMAP_DEDUPE_SERVER_URL=https://adamspiers.org/computing/mail/dedupe-server/$MAIL_PROFILE

export MAIL_DAEMON_LOG=$MAIL_PROFILE_LOG/daemon.log
export MAIL_DAEMON_LOCK=$MAIL_PROFILE_DIR/.daemon.lock

export MSMTP_CONFIG=$MAIL_PROFILE_DIR/.msmtprc

export MUTT_CACHE_DIR=~/.cache/mutt/$MAIL_PROFILE
# Needed so smime_keys can query the current mutt config
export MUTT_CMDLINE="mutt -F $HOME/.mutt/$MAIL_PROFILE"
