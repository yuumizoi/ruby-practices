# frozen_string_literal: true

require_relative 'file_entry'

class FileSystem
  def initialize(all: false, reverse: false)
    @all = all
    @reverse = reverse
  end
end
