# frozen_string_literal: true

COLUMN_COUNT = 3

def calc_max_width(file_names)
  file_names.map(&:size).max
end

def fetch_visiable_files
  Dir.entries('.')
     .reject { |name| name.start_with?('.') }
     .sort
end

def display_files(file_names, width)
  # 行数を計算
  row_count = (file_names.size.to_f / COLUMN_COUNT).ceil
  # 不足分を空文字で埋め、3列分のマス目を満たす
  padding_count = row_count * COLUMN_COUNT - file_names.size
  file_names += [''] * padding_count

  row_count.times do |row_index|
    row = []
    COLUMN_COUNT.times do |col_index|
      index = row_index + row_count * col_index
      row << file_names[index].ljust(width)
    end
    puts row.join('  ')
  end
end

file_names = fetch_visiable_files
width = calc_max_width(file_names)
display_files(file_names, width)
