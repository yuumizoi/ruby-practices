COLUMN_COUNT = 3

def calc_max_width(file_names)
    file_names.map(&:size).max
end

def fetch_visiable_files
    Dir.entries('.').reject { |name| name.start_with?('.') }
end

def display_files(file_names)
    file_names.each { |name| puts name }
end

# ▼ 動作確認用テストコード
file_names = fetch_visiable_files
width = calc_max_width(file_names)
puts "最大の幅は #{width} 文字です"
display_files(file_names)
