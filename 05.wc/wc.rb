#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def parse_options
    opt = OptionParser.new
    options = {}
    opt.on('-l', 'count lines') { options[:l] = true }
    opt.parse!(ARGV)
    options
end

opts = parse_options
pipe_input = ARGV.empty? && !STDIN.tty?

text = STDIN.read if pipe_input
name = nil if pipe_input
text = File.read(ARGV.first, mode: 'rb') unless pipe_input
name = ARGV.first unless pipe_input
