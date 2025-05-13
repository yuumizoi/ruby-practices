#!/usr/bin/env ruby
# frozen_string_literal: true

score_string = ARGV[0]
scores = score_string.split(',')

shots = scores.map { |score_string_item| score_string_item == 'X' ? 10 : score_string_item.to_i }

frames = []
index = 0

while index < shots.length && frames.length < 10
  if frames.length == 9
    frames << shots[index..]
    break
  elsif shots[index] == 10
    frames << [10]
    index += 1
  else
    frames << [shots[index], shots[index + 1]]
    index += 2
  end
end

point = 0 # point の初期化

frames.size.times do |i|
  point += frames[i].sum # 基本点
  next if i == 9

  if frames[i][0] == 10
    point += frames[i + 1][0]
    point += frames[i + 1][1] || frames[i + 2][0]
  elsif frames[i].sum == 10
    point += frames[i + 1][0]
  end
end

puts point
