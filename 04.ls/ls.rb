# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'shellwords'

COLUMN_COUNT = 3

def calc_max_width(file_names)
  file_names.map(&:size).max
end

def fetch_visible_files(all:)
  flags = all ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags).sort
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

def file_type_char(stat)
  case stat.ftype
  when 'directory' then 'd'
  when 'link' then 'l'
  when 'characterSpecial' then 'c'
  when 'blockSpecial' then 'b'
  when 'socket' then 's'
  when 'fifo' then 'p'
  when 'file' then '-'
  else '?'
  end
end

def format_mtime_for_ls(time, _now = Time.now)
  time.strftime('%-m %e %H:%M')
end

# ---- options ----
all = false
reverse = false
long = false
OptionParser.new do |opt|
  opt.on('-a') { all = true }
  opt.on('-r') { reverse = true }
  opt.on('-l') { long = true }
end.parse!(ARGV)

# ---- files ----
file_names = fetch_visible_files(all: all)
file_names.reverse! if reverse

# ---- output ----
if long
  stats = file_names.map { |n| [n, File.lstat(n)] }
  total_blocks = stats.sum { |_, st| st.blocks || ((st.size + 511) / 512) }
  puts "total #{total_blocks}"

  link_count_width = [1, *stats.map { |_, st| st.nlink.to_s.size }].max
  user_name_width  = [1, *stats.map { |_, st| (Etc.getpwuid(st.uid)&.name || st.uid.to_s).size }].max
  group_name_width = [1, *stats.map { |_, st| (Etc.getgrgid(st.gid)&.name || st.gid.to_s).size }].max
  file_size_width  = [1, *stats.map { |_, st| st.size.to_s.size }].max
  mtime_width      = [1, *stats.map { |_, st| format_mtime_for_ls(st.mtime).size }].max

  stats.each do |name, st|
    user  = Etc.getpwuid(st.uid)&.name || st.uid.to_s
    group = Etc.getgrgid(st.gid)&.name || st.gid.to_s

    type_char = file_type_char(st)

    m = st.mode & 0o777
    perms = [
      (m & 0o400).zero? ? '-' : 'r', (m & 0o200).zero? ? '-' : 'w', (m & 0o100).zero? ? '-' : 'x',
      (m & 0o040).zero? ? '-' : 'r', (m & 0o020).zero? ? '-' : 'w', (m & 0o010).zero? ? '-' : 'x',
      (m & 0o004).zero? ? '-' : 'r', (m & 0o002).zero? ? '-' : 'w', (m & 0o001).zero? ? '-' : 'x'
    ].join
    permstr = type_char + perms

    # 拡張属性が付いている場合は @ を追加（macOS）
    begin
      xattr_output = `xattr -l -- #{Shellwords.escape(name)} 2>/dev/null`
      has_xattr = !xattr_output.strip.empty?
    rescue StandardError
      has_xattr = false
    end
    permstr += '@' if has_xattr

    mtime = format_mtime_for_ls(st.mtime)
    printf "%-11s %#{link_count_width}d %-#{user_name_width}s  %-#{group_name_width}s  %#{file_size_width}d  %-#{mtime_width}s %s\n",
           permstr, st.nlink, user, group, st.size, mtime, name
  end
else
  width = calc_max_width(file_names)
  display_files(file_names, width)
end
