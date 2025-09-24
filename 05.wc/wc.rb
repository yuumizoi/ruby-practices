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
