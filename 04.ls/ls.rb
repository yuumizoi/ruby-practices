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

    # 確認用に表示
    puts "ファイル数： #{file_names.size.to_f}"
    puts "必要な行数： #{row_count}"

    # 不足分を空文字で埋め、3列分のマス目を満たす
    padding_count = row_count * COLUMN_COUNT - file_names.size
    file_names += [""] * padding_count

    # 追加された空文字が何個かを表示
    puts "追加された空文字の数: #{padding_count}"

    # 右詰め1列表示（整形前）
    file_names.each { |name| puts name.rjust(width) }
end

# ▼ ›動作確認用テストコード（開発後に削除予定）
file_names = fetch_visiable_files
width = calc_max_width(file_names)
display_files(file_names, width)
