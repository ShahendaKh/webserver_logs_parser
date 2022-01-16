# frozen_string_literal: true

require_relative 'file_loader_service'
require_relative 'logs_insights_service'
require_relative 'visits_storage'

# Service to start parsing logic
class LogsParserService
  attr_reader :log_file_lines
  attr_accessor :visits_storage

  def initialize(file_name)
    @log_file_lines = FileLoaderService.new(file_name).log_file_lines
    @visits_storage = VisitsStorage.new
  end

  def parse
    return if log_file_lines.nil?

    log_file_lines.each_with_index do |line, row_index|
      next unless parse_line(line, row_index)
    end
    LogsInsightsService.new(visits_storage).show_insights
  end

  private

  def validate_line(splitted_line, row_index)
    if splitted_line.length < 2
      puts "Missing values in row ##{row_index}"
      return false
    elsif splitted_line.length > 2
      puts "Extra values in row ##{row_index} are ignored"
    end
    true
  end

  def parse_line(line, row_index)
    splitted_line = line.split(' ')
    return false unless validate_line(splitted_line, row_index)

    visited_url = splitted_line[0]
    visitor_ip = splitted_line[1]
    visits_storage.add_visit(visited_url, visitor_ip)
  end
end
