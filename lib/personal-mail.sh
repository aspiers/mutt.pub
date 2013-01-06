#!/bin/sh

export MAIL_PROFILE=personal
export OFFLINEIMAP_SERVER=imap.googlemail.com
# export LDAP_SERVER=fixme
# export LDAP_BASE=fixme

. ~/lib/common-mail.sh

OFFLINEIMAP_CURRENT_MONTH=$MAIL_PROFILE_DIR/archive/gm/`date +'%Y-%m'`
#OFFLINEIMAP_PREV_MONTH=$MAIL_PROFILE_DIR/archive/gm/`date +'%Y-%m' -d "$(date +%Y-%m-15) -1 month"`
export OFFLINEIMAP_DEDUPE="$OFFLINEIMAP_INBOX $OFFLINEIMAP_CURRENT_MONTH"
