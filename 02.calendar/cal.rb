#!/usr/bin/env ruby
require "date"

year = nil
month = nil

ARGV.each_with_index do |value, index|
  if value == "-y"
    year = ARGV[index + 1].to_i if ARGV[index + 1]
  elsif value == "-m"
    month = ARGV[index + 1].to_i if ARGV[index + 1]
  end
end

year ||= Date.today.year
month ||= Date.today.month

def generate_calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)

  puts "#{year}年#{month}月".center(20)
  puts " Su Mo Tu We Th Fr Sa"
  print "   " * first_day.wday

  (1..last_day.day).each do |day|
    if day < 10
      print "  #{day}"
    else
      print " #{day}"
    end
    if (first_day + (day - 1)).wday == 6
      print "\n"
    end
  end
  print "\n"
end

generate_calendar(year, month)
