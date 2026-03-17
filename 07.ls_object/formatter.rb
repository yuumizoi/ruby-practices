# frozen_string_literal: true

class Formatter
  def initialize(entries)
    @entries = entries
  end
  def rows_count
    @entries.size.ceildiv(3)
  end
  def ordered_rows
    rows = []
    @entries.each_slice(rows_count) do |slice|
      rows << (slice + [nil] * (rows_count - slice.size))
    end
    rows.transpose
  end
end
