#!/bin/sh

export MAIL_PROFILE=personal
export OFFLINEIMAP_SERVER=imap.googlemail.com

. ~/lib/common-mail.sh

export OFFLINEIMAP_DEDUPE="$OFFLINEIMAP_INBOX"
