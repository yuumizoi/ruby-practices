# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots[0].pins == 10
  end

  def spare?
    !strike? && @shots[0..1].sum(&:pins) == 10
  end

  def score
    @shots.sum(&:pins)
  end

  def pins_at(index)
    @shots[index]&.pins || 0
  end
end
