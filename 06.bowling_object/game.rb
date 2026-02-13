# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_string)
    marks = score_string.split(',')
    @shots = marks.map { |mark| Shot.new(mark) }
    @frames = build_frames
  end

  def calculate_total_score
    total_score = 0
    @frames.each_with_index do |frame, i|
      total_score += frame.score
      total_score += bonus_score(i, frame.strike?) if i < 9 && (frame.strike? || frame.spare?)
    end
    total_score
  end

  private

  def build_frames
    frames = []
    index = 0

    while index < @shots.length && frames.length < 10
      if frames.length == 9
        frames << Frame.new(@shots[index..])
        break
      elsif @shots[index].pins == 10
        frames << Frame.new([@shots[index]])
        index += 1
      else
        frames << Frame.new([@shots[index], @shots[index + 1]])
        index += 2
      end
    end
    frames
  end

  def bonus_score(index, is_strike)
    next_frame = @frames[index + 1]
    if is_strike
      next_frame.pins_at(0) + (next_frame.pins_at(1) || @frames[index + 2].pins_at(0))
    else
      next_frame.pins_at(0)
    end
  end
end
