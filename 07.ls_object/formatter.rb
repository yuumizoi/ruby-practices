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

  def max_name_width
    @entries.map { |e| e.name.size }.max || 0
  end

  def format_name(entry)
    return "" if entry.nil?
    entry.name.ljust(max_name_width + 2)
  end

  def display
    ordered_rows.each do |row|
      line = row.map { |entry| format_name(entry) }.join
      puts line.rstrip
    end
  end

  def total_blocks
    @entries.sum(&:blocks)
  end

  def display_long
    puts "total #{total_blocks}"
  end
end
