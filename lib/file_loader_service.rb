# frozen_string_literal: true

# Service to validate log file exists and read it in lines
class FileLoaderService
  attr_reader :log_file_lines

  def initialize(file_name)
    file_path = File.expand_path("../../data/#{file_name}", __FILE__)
    begin
      @log_file_lines = File.readlines(file_path)
    rescue Errno::ENOENT
      puts 'Log file could not be found'
    end
  end
end
