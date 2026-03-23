#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'options'
require_relative 'file_system'
require_relative 'formatter'

def main
  options = Options.new(ARGV)

  fs = FileSystem.new(all: options.all?, reverse: options.reverse?)
  entries = fs.entries
  formatter = Formatter.new(entries)

  if options.long_format?
    formatter.display_long
  else
    formatter.display
  end
end

main
