# frozen_string_literal: true

require 'optparse' # ← 追加：-l を受け取るため
require 'etc' # ← 追加 : ユーザー/グループ名の取得に使用

COLUMN_COUNT = 3

def calc_max_width(file_names)
  file_names.map(&:size).max
end

def fetch_visible_files
  Dir.glob('*').sort
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

long = false
OptionParser.new { |opt| opt.on('-l') { long = true } }.parse!(ARGV)

file_names = fetch_visible_files
if long
  stats = file_names.map { |n| [n, File.lstat(n)] }
  link_count_width = [1, *stats.map { |_, st| st.nlink.to_s.size }].max
  user_name_width = [1, *stats.map { |_, st| (Etc.getpwuid(st.uid)&.name || st.uid.to_s).size }].max
  stats.each do |name, st|
    printf "%#{link_count_width}d %-#{user_name_width}s %s\n", st.nlink, (Etc.getpwuid(st.uid)&.name || st.uid.to_s), name
  end
  # group_name_width = [1, *stats.map { |_, st| (Etc.getgrgid(st.gid)&.name || st.gid.to_s).size }].max
  # file_size_width = [1, *stats.map { |_, st| st.size.to_s.size }].max
  # いったん動作確認として、-l は1行=1ファイルの暫定表示
  file_names.each { |name| puts name }
else
  width = calc_max_width(file_names)
  display_files(file_names, width)
end
