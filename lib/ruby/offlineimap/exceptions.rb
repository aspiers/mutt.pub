#!/usr/bin/ruby

module OfflineIMAP
  class MailDirParseError < RuntimeError
    def initialize(maildir, file)
      @maildir = maildir
      @file = file
    end
  end

  class CorruptMailDirLocalStatus < RuntimeError
    def initialize(localstatus)
      @localstatus = localstatus
    end
  end
end
