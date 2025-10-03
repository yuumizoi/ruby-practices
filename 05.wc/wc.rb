#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-l', 'count lines') { options[:l] = true }
  opt.on('-w', 'count words') { options[:w] = true }
  opt.on('-c', 'count bytes') { options[:c] = true }
  opt.parse!(ARGV)
  options
end

opts = parse_options
opts = { l: true, w: true, c: true } unless opts.values.any?
stdin_mode = ARGV.empty?
input_files =
  if stdin_mode
    [{ name: nil, content: $stdin.read }]
  else
    ARGV.map { |path| { name: path, content: File.read(path, mode: 'rb') } }
  end
rows = []

total_l = 0
total_w = 0
total_c = 0

input_files.each do |file|
  line_count = file[:content].count("\n")
  word_count = file[:content].scan(/\S+/).length
  byte_count = file[:content].bytesize

  cols = []
  cols << line_count if opts[:l]
  cols << word_count if opts[:w]
  cols << byte_count if opts[:c]
  rows << (cols + [file[:name]])

  total_l += line_count
  total_w += word_count
  total_c += byte_count
end

if input_files.size >= 2
  cols = []
  cols << total_l if opts[:l]
  cols << total_w if opts[:w]
  cols << total_c if opts[:c]
  rows << (cols + ['total'])
end

col_count = %i[l w c].count { |option_key| opts[option_key] }
widths = Array.new(col_count, 8)

rows.each do |row|
  numbers = (0...col_count).map { |col_index| row[col_index].to_s.rjust(widths[col_index]) }
  num_part = numbers.join
  if row[col_count]
    puts "#{num_part} #{row[col_count]}"
  else
    puts num_part
  end
end
