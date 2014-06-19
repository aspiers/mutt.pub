#!/usr/bin/ruby

require 'offlineimap/exceptions'
require 'offlineimap/localstatus'

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
end
