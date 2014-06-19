#!/usr/bin/ruby

require 'offlineimap/account'
require 'offlineimap/maildir'
require 'offlineimap/localstatus'

module OfflineIMAP
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
