#!/usr/bin/env ruby
# frozen_string_literal: true

score_string = ARGV[0]
scores = score_string.split(',')

shots = []

scores.each do |score_string_item|
  if score_string_item == 'X'
    shots << 10
  else
    shots << score_string_item.to_i
  end
end

frames = []
index = 0

while index < shots.length && frames.length < 10
  if shots[index] == 10
    frames << [10]
    index += 1
  else
    frames << [shots[index], shots[index + 1]]
    index += 2
  end
end

puts frames.inspect
