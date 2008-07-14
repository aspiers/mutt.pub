#!/usr/bin/ruby

class MailDir
  attr_reader :path

  def initialize(path)
    @path = path
    %w(cur new tmp).each do |subdir|
      dir = File.join(@path, subdir)
      unless FileTest.directory?(dir)
        raise MailDirPathError.new(@path, subdir), "#{dir} not a directory"
      end
    end
  end

  def each_file
    %w(cur new).each do |subdir|
      dir = File.join(@path, subdir)
      unless FileTest.directory? dir
        raise MailDirPathError.new(@path, subdir), "#{dir} not a directory"
      end
      Dir.foreach(dir) do |file|
        path = File.join(dir, file)
        next unless FileTest.file? path
        yield path, file
      end
    end
  end
end

class MailDirPathError < RuntimeError
  attr_reader :dir, :missing

  def initialize(dir, missing)
    @dir = dir
    @missing = missing
  end
end
