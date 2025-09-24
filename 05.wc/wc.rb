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
pipe_input = ARGV.empty? && !STDIN.tty?

text = STDIN.read if pipe_input
name = nil if pipe_input
text = File.read(ARGV.first, mode: 'rb') unless pipe_input
name = ARGV.first unless pipe_input
lines = text.count("\n")
words = text.scan(/\S+/).length
bytes = text.bytesize

cols=[]; cols<<lines if opts[:l]; cols<<words if opts[:w]; cols<<bytes if opts[:c]
puts(name ? "#{cols.join(' ')} #{name}" : cols.join(' '))
