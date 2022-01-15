# frozen_string_literal: true

require_relative 'url_visit'

# Object to store visits in `visits_by_url` map with key: url, value: UrlVisit(url, visits_count, visitor_ips)
class VisitsStorage
  attr_accessor :visits_by_url

  def initialize
    @visits_by_url = {}
  end

  def add_visit(url, visitor_ip)
    if @visits_by_url.keys.include?(url)
      url_visit = @visits_by_url[url]
      url_visit.increment_visit visitor_ip
    else
      url_visit = UrlVisit.new(url, visitor_ip)
      @visits_by_url[url] = url_visit
    end
  end

  def visits_values
    @visits_by_url.values
  end

  def sort_visits_by_visits_count
    visits_values.sort_by(&:visits_count).reverse!
  end

  def sort_visits_by_unique_visitors
    visits_values.sort_by { |visit| visit.visitor_ips.uniq.count }.reverse!
  end

  def total_urls_visited
    @visits_by_url.keys.count
  end

  def total_visits_count
    visits_values.map(&:visits_count).inject(0, &:+)
  end

  def show_visits(sort_criteria)
    visits = sort_visits_by_criteria sort_criteria
    visits.each do |visit|
      puts "#{visit.url} visited #{visit.visits_count} times by #{visit.visitor_ips.uniq.count} unique visitors"
    end
  end

  private

  def sort_visits_by_criteria(sort_criteria)
    case sort_criteria
    when 'visits_count'
      sort_visits_by_visits_count
    when 'unique_visitors'
      sort_visits_by_unique_visitors
    else
      puts 'Sorting criteria not recognized'
      visits_values
    end
  end
end
