# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @options = {}
    opt = OptionParser.new
    opt.on('-a') { |v| @options[:all] = v }
    opt.on('-r') { |v| @options[:reverse] = v }
    opt.on('-l') { |v| @options[:long] = v }
    opt.parse!(argv)
  end

  def all?
    @options[:all]
  end

  def reverse?
    @options[:reverse]
  end

  def long_format?
    @options[:long]
  end
end
