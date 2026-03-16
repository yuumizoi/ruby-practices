# frozen_string_literal: true

require_relative 'file_entry'

class FileSystem
  def initialize(all: false, reverse: false)
    @all = all
    @reverse = reverse
  end

  def names
    flags = @all ? File::FNM_DOTMATCH : 0
    list = Dir.glob('*', flags).sort
    list.reverse! if @reverse
    list
  end

  def entries
    names.map do |name|
      FileEntry.new(name)
    end
  end
end
