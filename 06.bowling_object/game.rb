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

    while frames.length < 10
      if frames.length == 9
        frames << Frame.new(frames.length, shots[index..])
      elsif shots[index].strike?
        frames << Frame.new(frames.length, [shots[index]])
        index += 1
      else
        frames << Frame.new(frames.length, shots[index, 2])
        index += 2
      end
    end
    frames
  end
end
