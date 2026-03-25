# frozen_string_literal: true

class Formatter
  def initialize(entries)
    @entries = entries
  end

  def display
    ordered_rows.each do |row|
      line = row.map { |entry| format_name(entry) }.join
      puts line.rstrip
    end
  end

  def display_long
    puts "total #{total_blocks}"

    w = max_widths

    @entries.each do |entry|
      formatted_row = [
        entry.mode.ljust(10),
        entry.nlink.to_s.rjust(w[:nlink]),
        entry.user.ljust(w[:user] + 1),
        entry.group.ljust(w[:group]),
        entry.size.to_s.rjust(w[:size] + 1),
        entry.mtime.rjust(w[:time] + 1),
        entry.name
      ]
      puts formatted_row.join(' ')
    end
  end

  private

  def total_blocks
    @entries.sum(&:blocks)
  end

  def max_widths
    {
      nlink: @entries.map { |e| e.nlink.to_s.size }.max,
      user: @entries.map { |e| e.user.size }.max,
      group: @entries.map { |e| e.group.size }.max,
      size: @entries.map { |e| e.size.to_s.size }.max,
      time: @entries.map { |e| e.mtime.size }.max
    }
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
    return '' if entry.nil?

    entry.name.ljust(max_name_width + 2)
  end
end
