#!/usr/bin/ruby

require 'maildir'
require 'offlineimap/localstatus'

module OfflineIMAP
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
end
