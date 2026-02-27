# frozen_string_literal: true

class Shot
  attr_reader :pins

  def initialize(mark)
    @pins = convert_to_pins(mark)
  end

  def strike?
    @pins == 10
  end

  private

  def convert_to_pins(mark)
    mark == 'X' ? 10 : mark.to_i
  end
end
