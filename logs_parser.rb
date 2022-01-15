# frozen_string_literal: true

script_arguments = ARGV
if script_arguments.empty?
  puts 'Please enter log file name saved in data folder or an absolute file path'
  return
end
file_path = File.expand_path("../data/#{script_arguments[0]}", __FILE__)
begin
  File.readlines(file_path)
rescue Errno::ENOENT
  puts 'Log file could not be found'
  return
end
