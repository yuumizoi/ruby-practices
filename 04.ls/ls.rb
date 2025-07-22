COLUMN_COUNT = 3

def calc_max_width(file_names)
    file_names.map(&:size).max
end

def fetch_visiable_files
    Dir.entries('.').reject { |name| name.start_with?('.') }
end

def display_files(file_names, width)
    # 行数を計算
    row_count = (file_names.size.to_f / COLUMN_COUNT).ceil

    # 確認用に表示
    puts "ファイル数： #{file_names.size.to_f}"
    puts "必要な行数： #{row_count}"

    # 右詰め1列表示
    file_names.each { |name| puts name.rjust(width) }
end

# ▼ ›動作確認用テストコード（開発後に削除予定）
file_names = fetch_visiable_files
width = calc_max_width(file_names)
display_files(file_names, width)
