#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')

shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
  else
    shots << s.to_i
  end
end

point = 0
index = 0

10.times do
  if shots[index] == 10
    # ストライクの処理
    point += 10 + shots[index + 1] + shots[index + 2]
    index += 1
  elsif shots[index] + shots[index + 1] == 10
    # スペアの処理
    point += 10 + shots[index + 2]
    index += 2
  else
    # 通常の処理
    point += shots[index] + shots[index + 1]
    index += 2
  end
end

puts point
