#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')

shots = []

scores.each do |score_value|
  if score_value == 'X'
    shots << 10
  else
    shots << score_value.to_i
  end
end

point = 0
index = 0

10.times do |frame_index|
  if frame_index == 9
    if shots[index] == 10
      point += 10 + shots[index + 1] + shots[index + 2]
    elsif shots[index] + shots[index + 1] == 10
      point += 10 + shots[index + 2]
    else
      point += shots[index] + shots[index + 1]
    end
  else
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
end

puts point
