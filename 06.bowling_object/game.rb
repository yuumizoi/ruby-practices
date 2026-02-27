# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_string)
    marks = score_string.split(',')
    shots = marks.map { |mark| Shot.new(mark) }
    @frames = build_frames(shots)
  end

  def calculate_score
    @frames.sum { |frame| frame.calculate_score(@frames) }
  end

  private

  def build_frames(shots)
    frames = []
    index = 0
    while index < shots.size
      shot_length = if frames.length == 9
                      shots.size - index
                    elsif shots[index].strike?
                      1
                    else
                      2
                    end
      frames << Frame.new(frames.length, shots[index, shot_length])
      index += shot_length
    end
    frames
  end
end
