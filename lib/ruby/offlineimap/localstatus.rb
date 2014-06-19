#!/usr/bin/ruby

require 'offlineimap/exceptions'

module OfflineIMAP
  class MailDirLocalStatus
    def MailDirLocalStatus.header
      "OFFLINEIMAP LocalStatus CACHE DATA - DO NOT MODIFY - FORMAT 1"
    end

    attr_reader :account, :maildir, :uids

    def initialize(account, maildir)
      @account = account
      @maildir = maildir
      unless FileTest.file?(path)
        raise CorruptMailDirLocalStatus.new(self), "#{path} not a file"
      end
      get_uids
    end

    def get_uids
      @uids = {}
      firstline = true
      IO.foreach(path) do |line|
        if firstline
          unless line =~ /^OFFLINEIMAP LocalStatus CACHE DATA - DO NOT MODIFY - FORMAT \d+/
            raise CorruptMailDirLocalStatus.new(self),
                  "corrupt first line in #{path}:\n" + line
          end
          firstline = false
        else
          unless line =~ /^(\d+):([FRS]*)$/
            raise CorruptMailDirLocalStatus.new(self),
                  "corrupt UID line in #{path}:\n" + line
          end
          @uids[$1] = $2
        end
      end
    end

    def path
      File.join(account.localstatus_dir, @maildir)
    end
  end
end
