# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/url_visit'

RSpec.describe 'Url visit' do
  describe 'Store url visits information' do
    context 'Create url visit' do
      let(:create_url_visit) { UrlVisit.new('/home', '184.123.665.067') }
      it 'Visit information saved with visits count = 1' do
        expect(create_url_visit).to(satisfy { |visit| visit.url == '/home' })
        expect(create_url_visit).to(satisfy { |visit| visit.visits_count == 1 })
        expect(create_url_visit).to(satisfy do |visit|
                                      visit.visitor_ips.length == 1 && visit.visitor_ips.include?('184.123.665.067')
                                    end)
      end
    end
    context 'Create url visit and increment it with another ip address' do
      let(:create_url_visit) do
        visit = UrlVisit.new('/home', '184.123.665.067')
        visit.increment_visit('194.123.665.067')
        visit
      end
      it 'Visit information saved with visits count = 2' do
        expect(create_url_visit).to(satisfy { |visit| visit.url == '/home' })
        expect(create_url_visit).to(satisfy { |visit| visit.visits_count == 2 })
        expect(create_url_visit).to(satisfy do |visit|
          visit.visitor_ips.length == 2 &&
          visit.visitor_ips - ['184.123.665.067', '194.123.665.067'] == []
        end)
      end
    end
  end
end
