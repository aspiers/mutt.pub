#!/usr/bin/ruby

require 'maildir'

module OfflineIMAP
  class Account
    attr_reader :name

    def initialize(dir, name)
      @dir = dir
      @name = name
      path = localstatus_dir
      raise "#{path} not a directory" \
        unless FileTest.directory?(path)
    end

    def localstatus_dir
      File.join(@dir, "Account-" + @name, 'LocalStatus')
    end

    def each_maildir_localstatus
      Dir.foreach(localstatus_dir) do |folder|
        next if folder =~ /^\.\.?$/
        begin
          localstatus = OfflineIMAP::MailDirLocalStatus.new self, folder
          yield localstatus
        rescue OfflineIMAP::CorruptMailDirLocalStatus => exception
          puts "!! skipping #{folder}:"
          puts exception.message.gsub(/^/, '  ').gsub(ENV['HOME'], "~")
        end
      end
    end
  end

  class MailDir < MailDir
    attr_reader :new_mails

    def uids
      get_uids unless @uids
      return @uids
    end

    def get_uids
      @uids = {}
      @new_mails = []
      each_file do |path, file|
        unless file =~ /,U=(\d+),.*:2,(.*)/
          @new_mails.push file
          next
        end
        uid, flags = $1, $2
        @uids[uid] = flags
      end
    end
    private :get_uids

    def localstatus
      out = OfflineIMAP::MailDirLocalStatus.header + "\n"
      uids.sort { |a,b| a[0].to_i <=> b[0].to_i }.each do |uid, flags|
        out += uid + ":" + flags + "\n"
      end
      # or:
      #
      # uids.keys.sort { |a,b| a.to_i <=> b.to_i }.each do |uid|
      #   out += uid + ":" + uids[uid] + "\n"
      # end
      return out
    end
  end

  class MailDirParseError < RuntimeError
    def initialize(maildir, file)
      @maildir = maildir
      @file = file
    end
  end

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

  class CorruptMailDirLocalStatus < RuntimeError
    def initialize(localstatus)
      @localstatus = localstatus
    end
  end

  def OfflineIMAP::compare_localstatus_with_maildir(localstatus, maildir)
    differences = []

    localstatus.uids.keys.sort {|a,b| a.to_i<=>b.to_i}.each do |uid|
      ls_flags = localstatus.uids[uid]
      if md_flags = maildir.uids[uid]
        if md_flags != ls_flags
          differences.push "  uid #{uid} flag mismatch: localstatus=#{ls_flags}, maildir=#{md_flags}"
        else
#          differences.push "  uid #{uid} flags match: localstatus=#{ls_flags}, maildir=#{md_flags}"
        end
      else
        differences.push "  uid #{uid} in localstatus but not in maildir - would DELETE remote copy"
      end
    end

    maildir.uids.keys.sort {|a,b| a.to_i <=> b.to_i}.each do |uid|
      if ! localstatus.uids[uid]
        differences.push "  uid #{uid} in maildir but not in localstatus - would upload?"
      end
    end
    
    return differences
  end    
end
