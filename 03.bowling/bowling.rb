#!/usr/bin/env ruby
# frozen_string_literal: true

score_string = ARGV[0]
scores = score_string.split(',')

shots = []

scores.each do |score_string_item|
  shots << (score_string_item == 'X' ? 10 : score_string_item.to_i)
end

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
  point += if i <= 8 # 1〜9フレームの処理
             if frames[i][0] == 10 # ストライク
               if i + 2 < frames.length && frames[i + 1][0] == 10
                 10 + frames[i + 1][0] + frames[i + 2][0]
               else
                 10 + frames[i + 1][0] + frames[i + 1][1]
               end
             elsif frames[i][0] + frames[i][1] == 10 && i + 1 < frames.length
               10 + frames[i + 1][0]
             else # 通常フレーム
               frames[i][0] + frames[i][1]
             end
           elsif frames[9][0] == 10
             # 10フレーム目の処理（i == 9）
             frames[9][0] + frames[9][1] + frames[9][2]
           elsif frames[9][0] + frames[9][1] == 10
             frames[9][0] + frames[9][1] + frames[9][2]
           else
             frames[9][0] + frames[9][1]
           end
end

puts point
