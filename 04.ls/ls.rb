# frozen_string_literal: true

require 'optparse'

all = false
reverse = false

opts = OptionParser.new
opts.on('-a') { all = true }
opts.on('-r') { reverse = true }
opts.parse!(ARGV)

COLUMN_COUNT = 3

def calc_max_width(file_names)
  file_names.map(&:size).max
end

def fetch_visible_files(all:)
  (all ? Dir.entries('.') : Dir.glob('*')).sort
end

def display_files(file_names, width)
  # 行数を計算
  row_count = file_names.size.ceildiv(COLUMN_COUNT)
  # 不足分を空文字で埋め、3列分のマス目を満たす
  padding_count = row_count * COLUMN_COUNT - file_names.size
  file_names += [''] * padding_count

  row_count.times do |row_index|
    row = Array.new(COLUMN_COUNT) do |col_index|
      index = row_index + row_count * col_index
      file_names[index].ljust(width)
    end
    puts row.join('  ')
  end
end

file_names = fetch_visible_files(all: all)
file_names.reverse! if reverse
width = calc_max_width(file_names)
display_files(file_names, width)
