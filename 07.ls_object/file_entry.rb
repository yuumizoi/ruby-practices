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

  def mode
    type + permissions
  end

  def type
    FTYPE_TO_CHAR.fetch(@stat.ftype, '?')
  end

  def permissions
    m = @stat.mode & 0o777
    (0..8).map { |i| rwx_char(m, 0o400 >> i, 'rwx'[i % 3]) }.join
  end

  def rwx_char(mode, mask, char)
    (mode & mask).zero? ? '-' : char
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime.strftime('%-m %e %H:%M')
  end

  def nlink
    @stat.nlink
  end

  def blocks
    @stat.blocks
  end
end
