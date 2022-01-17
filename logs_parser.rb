# frozen_string_literal: true

require_relative 'lib/services/logs_parser_service'

script_arguments = ARGV
if script_arguments.empty?
  puts 'ERROR: Please enter log file name saved in data folder or an absolute file path'
  return
end

LogsParserService.new(script_arguments[0]).parse
