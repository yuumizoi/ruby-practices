#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-l', 'count lines'){ options[:l] = true }
  opt.on('-w', 'count words'){ options[:w] = true }
  opt.on('-c', 'count bytes'){ options[:c] = true }
  opt.parse!(ARGV)
  options
end

opts = parse_options
opts = { l: true, w: true, c: true } unless opts.values.any?
pipe_input = ARGV.empty? && !STDIN.tty?
rows = []

if pipe_input
  text  = STDIN.read
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
    t = File.read(path, mode: 'rb')
    l = t.count("\n")
    w = t.scan(/\S+/).length
    c = t.bytesize

    total_l += l
    total_w += w
    total_c += c

    cols = []
    cols << l if opts[:l]
    cols << w if opts[:w]
    cols << c if opts[:c]
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
