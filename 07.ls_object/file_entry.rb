# frozen_string_literal: true

require 'etc'
require 'shellwords'

class FileEntry
  attr_reader :name
  
  def initialize(name)
    @name = name
    @stat = File.lstat(name)
  end
end
