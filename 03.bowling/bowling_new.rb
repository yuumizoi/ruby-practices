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
  if frame[0] == 10
    if frames[i][0] == 10
      point += 10
      if i + 1 < frames.length
        point += frames[i + 1][0]
        if frames[i + 1][0] != 10
          point += frames[i + 1][1]
        else
          if i + 2 < frames.length
            point += frames[i + 2][0]
          end
        end
      end
    end
  elsif [(frame[0][0]) + (frame[0][1])] == 10  # ここにスペアの条件を書く
    # スペアのスコア計算
  else
    if frames[i][0] + frames[i][1] < 10
      point += frames[i][0] + frames[i][1]
    end
    
  end
end

puts point
