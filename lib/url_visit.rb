# frozen_string_literal: true

# Object to store a url's visits' information
class UrlVisit
  attr_accessor :url, :visits_count, :visitor_ips

  def initialize(url, visitor_ip)
    @url = url
    @visits_count = 1
    @visitor_ips = [visitor_ip]
  end

  def increment_visit(visitor_ip)
    @visits_count += 1
    @visitor_ips << visitor_ip
  end
end
