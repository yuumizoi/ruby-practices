# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'shellwords'

COLUMN_COUNT = 3

FTYPE_TO_CHAR = {
  'directory' => 'd',
  'link' => 'l',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'socket' => 's',
  'fifo' => 'p',
  'file' => '-'
}.freeze

def file_type_char(stat)
  FTYPE_TO_CHAR.fetch(stat.ftype, '?')
end

def name_column_width(file_names)
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

def format_mtime_for_ls(time, _now = Time.now)
  time.strftime('%-m %e %H:%M')
end

def max_width(values)
  values.map { |v| v.to_s.size }.max
end

def compute_widths(stats)
  file_stats = stats.map { |_, s| s }
  users  = file_stats.map { |s| Etc.getpwuid(s.uid)&.name || s.uid.to_s }
  groups = file_stats.map { |s| Etc.getgrgid(s.gid)&.name || s.gid.to_s }
  {
    link:  max_width(file_stats.map(&:nlink)),
    user:  max_width(users),
    group: max_width(groups),
    size:  max_width(file_stats.map(&:size)),
    mtime: max_width(file_stats.map { |s| format_mtime_for_ls(s.mtime) })
  }
  end

def compute_total_blocks(file_stats)
  file_stats.sum { |st| st.blocks || ((st.size + 511) / 512) }
end

def xattr?(name)
  xattr_output = `xattr -l -- #{Shellwords.escape(name)} 2>/dev/null`
  !xattr_output.strip.empty?
rescue StandardError
  false
end

def permissions_str(stat)
  m = stat.mode & 0o777
  (0..8).map { |i| rwx_char(m, 0o400 >> i, 'rwx'[i % 3]) }.join
end

def rwx_char(mode, mask, char)
  (mode & mask).zero? ? '-' : char
end

def build_permstr(stat, name)
  permstr = file_type_char(stat) + permissions_str(stat)
  permstr += '@' if xattr?(name)
  permstr
end

def print_output(file_names, long)
# 非 -l で一覧が空なら何も出力しない
return if !long && file_names.empty?
return print_long_listing(file_names) if long

  width = name_column_width(file_names)
  display_files(file_names, width)
end

def print_long_listing(file_names)
  stats = file_names.map { |n| [n, File.lstat(n)] }
  file_stats = stats.map { |_, st| st }
  puts "total #{compute_total_blocks(file_stats)}"
  return if stats.empty?

  widths = compute_widths(stats)
  stats.each do |name, st|
    user  = Etc.getpwuid(st.uid)&.name || st.uid.to_s
    group = Etc.getgrgid(st.gid)&.name || st.gid.to_s
    permstr = build_permstr(st, name)
    mtime = format_mtime_for_ls(st.mtime)
    printf(
      "%-11s %#{widths[:link]}d %-#{widths[:user]}s  %-#{widths[:group]}s  %#{widths[:size]}d  %-#{widths[:mtime]}s %s\n",
      permstr, st.nlink, user, group, st.size, mtime, name
    )
  end
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
file_names = fetch_visible_files(all:)
file_names.reverse! if reverse

# ---- output ----
print_output(file_names, long)
