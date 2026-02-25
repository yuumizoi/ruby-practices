# frozen_string_literal: true

class Frame
  def initialize(index, shots)
    @index = index
    @shots = shots
  end

  def calculate_score(all_frames)
    total = sum_pins
    total += bonus_score(all_frames) if @index < 9 && (strike? || spare?)
    total
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && sum_pins == 10
  end

  def pins_at(index)
    @shots[index]&.pins || 0
  end

  private

  def sum_pins
    @shots.sum(&:pins)
  end

  def bonus_score(all_frames)
    next_frame = all_frames[@index + 1]
    if strike?
      bonus = next_frame.pins_at(0)
      bonus += if next_frame.strike? && @index < 8
                 all_frames[@index + 2].pins_at(0)
               else
                 next_frame.pins_at(1)
               end
      bonus
    else
      next_frame.pins_at(0)
    end
  end
end
