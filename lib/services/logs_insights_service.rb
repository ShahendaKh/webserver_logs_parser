# frozen_string_literal: true

# Service to show the insights collected by parsing logs
class LogsInsightsService
  attr_reader :visits_storage

  def initialize(visits_storage)
    @visits_storage = visits_storage
  end

  def show_insights
    puts "total urls visited: #{visits_storage.total_urls_visited}"
    puts "total visits count: #{visits_storage.total_visits_count}"
    puts "\n"
    puts 'visits sorted by visits count:'
    visits_storage.show_visits('visits_count')
    puts "\n"
    puts 'visits sorted by unique visitors:'
    visits_storage.show_visits('unique_visitors')
  end
end
