# frozen_string_literal: true

# Service to validate log file exists and read it in lines
class FileLoaderService
  attr_reader :log_file_lines

  def initialize(file_name)
    file_path = get_file_path(file_name)
    begin
      @log_file_lines = File.readlines(file_path)
    rescue Errno::ENOENT
      puts 'ERROR: Log file could not be found'
    end
  end

  private

  def get_file_path(file_name)
    file_path = File.expand_path("../../data/#{file_name}", __FILE__)

    File.exist?(file_path) ? file_path : file_name
  end
end
