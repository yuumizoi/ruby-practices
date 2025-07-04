def fetch_visiable_files
    Dir.entries('.').reject { |name| name.start_with?('.') }
end
def display_files(file_names)
    file_names.each { |name| puts name }
end

file_names = fetch_visiable_files
display_files(file_names)
