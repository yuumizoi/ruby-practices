#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')

shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

point = 0
index = 0

10.times do
  if shots[index] == 10
    # ストライク
    point += 10 + shots[index + 2] + shots[index + 3]
    index += 2
  elsif shots[index] + shots[index + 1] == 10
    point += 10 + shots[index + 2]
    index += 2
  else
    point += shots[index] + shots[index + 1]
    index += 2
  end
end

puts point
