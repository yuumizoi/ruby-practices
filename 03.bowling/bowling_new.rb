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

point = 0 # point の初期化

frames.each_with_index do |frame, i|
  if i <= 8 #1〜9フレームの処理
    if frames[i + 1][0] == 10
      point += 10
      if frames[i + 1][0] == 10 # 2フレーム目がストライク
        point += 10 + frames[i + 1][0] + frames[i + 2][0]
      else # 2フレーム目がストライクじゃない
        point += 10 + frames[i + 1][0] + frames[i + 1][1]
      end
    elsif frames[i][0] + frames[i][1] == 10 # スペアの処理
      point += 10 + frames[i + 1][0]
    else
      point += frames[i][0] + frames[i][1]
    end
  else
    if frames[9][0] == 10 # → ストライク：3投の加点
      point += 10 + frames[9][1] + frames[9][2]
    elsif frames[9][0] + frames[9][1] == 10 # → スペア：3投の加点
      point += frames[9][0] + frames[9][1] + frames[9][2]
    else # → 通常フレーム：2投の加点
      point += frames[9][0] + frames[9][1]
    end
  end
end

puts point
