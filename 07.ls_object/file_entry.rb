# frozen_string_literal: true

require 'etc'
require 'shellwords'

class FileEntry
  attr_reader :name
  
  def initialize(name)
    @name = name
    @stat = File.lstat(name)
  end

  FTYPE_TO_CHAR = {
  'directory' => 'd',
  'link' => 'l',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'socket' => 's',
  'fifo' => 'p',
  'file' => '-'
  }.freeze

  def type_char
    FTYPE_TO_CHAR.fetch(@stat.ftype, '?')
  end
end
