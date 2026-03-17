# frozen_string_literal: true

class Formatter
  def initialize(entries)
    @entries = entries
  end
  def rows_count
    @entries.size.ceildiv(3)
  end
end
