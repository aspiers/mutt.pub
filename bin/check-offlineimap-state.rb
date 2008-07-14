#!/usr/bin/ruby

require 'offlineimap'

default_account = ENV['OFFLINEIMAP_DEFAULT_ACCOUNT']
default_maildir = ENV['OFFLINEIMAP_MAIL_DIR']

def usage
  me = File.basename $0
  $stderr.puts <<EOF
Usage: #{me} ACCOUNT [MAILDIRS]
ACCOUNT defaults to #{default_account} ($OFFLINEIMAP_DEFAULT_ACCOUNT)
MAILDIRS defaults to #{default_maildir} ($OFFLINEIMAP_MAIL_DIR)
EOF
  exit 1
end

if ARGV.nitems > 2 || ARGV[0] == '-h' || ARGV[0] == '--help'
  usage
end

account_name = ARGV[0] || default_account
maildirs     = ARGV[1] || default_maildir
state_dir    = ENV['OFFLINEIMAP_STATE_DIR']

puts <<EOF
offlineimap account name: #{account_name}
path to maildirs:         #{maildirs}
offlineimap state dir:    #{state_dir}
EOF

account = OfflineIMAP::Account.new(state_dir, account_name)

account.each_maildir_localstatus do |localstatus|
  folder_name = localstatus.maildir
  begin
    maildir = OfflineIMAP::MailDir.new File.join(
      maildirs, folder_name
    )
    diffs = OfflineIMAP::compare_localstatus_with_maildir(localstatus, maildir)
    new = maildir.new_mails
    puts folder_name if diffs.length > 0 or new.length > 0
    puts diffs if diffs.length > 0
    puts new.map { |mail| "  new mail " + mail } if new.length > 0
  rescue MailDirPathError => exception
    $stderr.puts "invalid maildir %s (%s missing)" % \
      [exception.dir, exception.missing]
  end
#   if localstatus.uids.length > 0
#     print "uids for #{localstatus.maildir}: "
#     p localstatus.uids
#   end    
end

