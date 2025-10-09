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

  rows << { l: line_count, w: word_count, c: byte_count, name: file[:name] }

  total_l += line_count
  total_w += word_count
  total_c += byte_count
end

rows << { l: total_l, w: total_w, c: total_c, name: 'total' } if input_files.size >= 2

enabled_metric_keys = %i[l w c].select { |k| opts[k] }
COLUMN_WIDTH = 8
widths = Array.new(enabled_metric_keys.size, COLUMN_WIDTH)

rows.each do |file_result|
  formatted_columns = enabled_metric_keys.map.with_index { |k, i| file_result[k].to_s.rjust(widths[i]) }
  formatted_row = formatted_columns.join
  if file_result[:name]
    puts "#{formatted_row} #{file_result[:name]}"
  else
    puts formatted_row
  end
end
