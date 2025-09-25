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
pipe_input = ARGV.empty? && !$stdin.tty?
rows = []

if pipe_input
  text  = $stdin.read
  lines = text.count("\n")
  words = text.scan(/\S+/).length
  bytes = text.bytesize

  cols = []
  cols << lines if opts[:l]
  cols << words if opts[:w]
  cols << bytes if opts[:c]
  rows << (cols + [nil])
else
  total_l = 0
  total_w = 0
  total_c = 0

  ARGV.each do |path|
    content = File.read(path, mode: 'rb')
    line_count = content.count("\n")
    word_count = content.scan(/\S+/).length
    byte_count = content.bytesize
    total_l += line_count
    total_w += word_count
    total_c += byte_count

    cols = []
    cols << line_count if opts[:l]
    cols << word_count if opts[:w]
    cols << byte_count if opts[:c]
    rows << (cols + [path])
  end

  if ARGV.size >= 2
    cols = []
    cols << total_l if opts[:l]
    cols << total_w if opts[:w]
    cols << total_c if opts[:c]
    rows << (cols + ['total'])
  end
end

col_count = %i[l w c].count { |option_key| opts[option_key] }
widths = (0...col_count).map { |col_index| rows.map { |row| row[col_index].to_s.length }.max || 0 }

rows.each do |row|
  numbers = (0...col_count).map { |col_index| row[col_index].to_s.rjust(widths[col_index]) }
  num_part = numbers.join(' ')
  if row[col_count]
    puts "#{num_part} #{row[col_count]}"
  else
    puts num_part
  end
end
