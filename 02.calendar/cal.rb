#!/usr/bin/env ruby
require "date"
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on("-y YEAR", " --year YEAR", Integer, "カレンダーの年を指定します") do |year|
    options[:year] = year
  end
  opts.on("-m MONTH", "--month MONTH", Integer, "カレンダーの月を指定します") do |month|
    options[:month] = month
  end
end.parse!

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

def generate_calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)

  puts "#{year}年#{month}月".center(20)
  puts " 日 月 火 水 木 金 土"
  print "   " * first_day.wday

  (first_day..last_day).each do |date|
    print date.day.to_s.rjust(3)
    print "\n" if date.saturday?
  end
  print "\n"
end

generate_calendar(year, month)
