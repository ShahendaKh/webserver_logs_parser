# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/visits_storage'
RSpec.describe 'Visits storage' do
  describe 'Store log file information as key: url and value: UrlVisit' do
    context 'Create empty visits storage' do
      let(:create_visits_storage) { VisitsStorage.new }
      it 'Empty visits storage created' do
        expect(create_visits_storage).to(satisfy { |storage| storage.visits_by_url.empty? })
      end
    end
    context 'Create visits storage containing 2 urls' do
      let(:create_visits_storage) { test_storage }
      it 'Storage contains 2 entries' do
        expect(create_visits_storage).to(satisfy { |storage| storage.visits_by_url.length == 2 })
      end
    end
    context 'Add visits with missing arguments' do
      let(:create_faulty_visit) { faulty_test_storage }
      it 'ArgumentError is raised for missing argument' do
        expect { create_faulty_visit }.to raise_error(ArgumentError)
      end
    end
    context 'Get visits storage values' do
      let(:storage_values) { test_storage.visits_values }
      it 'Storage values retrieved successfully' do
        expect(storage_values).to(satisfy { |values| values.length == 2 })
        expect(storage_values).to(satisfy { |values| values.first.url == '/home' })
        expect(storage_values).to(satisfy { |values| values.first.visits_count == 3 })
        expect(storage_values).to(satisfy { |values| values[1].url == '/about' })
        expect(storage_values).to(satisfy { |values| values[1].visits_count == 4 })
      end
    end
    context 'Get visits storage values sorted by visits count' do
      let(:sort_values_by_visits_count) { test_storage.sort_visits_by_visits_count }
      it 'Storage values retrieved sorted by number of visits' do
        expect(sort_values_by_visits_count).to(satisfy { |values| values.length == 2 })
        expect(sort_values_by_visits_count).to(satisfy { |values| values.first.url == '/about' })
        expect(sort_values_by_visits_count).to(satisfy { |values| values.first.visits_count == 4 })
        expect(sort_values_by_visits_count).to(satisfy { |values| values[1].url == '/home' })
        expect(sort_values_by_visits_count).to(satisfy { |values| values[1].visits_count == 3 })
      end
    end
    context 'Get visits storage values sorted by the number of unique visitors' do
      let(:sort_values_by_unique_visitors) { test_storage.sort_visits_by_unique_visitors }
      it 'Storage values retrieved sorted by number of unique visitors' do
        expect(sort_values_by_unique_visitors).to(satisfy { |values| values.length == 2 })
        expect(sort_values_by_unique_visitors).to(satisfy { |values| values.first.url == '/home' })
        expect(sort_values_by_unique_visitors).to(satisfy { |values| values.first.visits_count == 3 })
        expect(sort_values_by_unique_visitors).to(satisfy { |values| values[1].url == '/about' })
        expect(sort_values_by_unique_visitors).to(satisfy { |values| values[1].visits_count == 4 })
      end
    end
    context 'Get total number of visited urls in storage' do
      let(:total_number_of_visited_urls) { test_storage.total_urls_visited }
      it 'Number of visited urls is correct' do
        expect(total_number_of_visited_urls).to eq(2)
      end
    end
    context 'Get total number of visits in storage' do
      let(:total_number_of_visits) { test_storage.total_visits_count }
      it 'Total number of visits is correct' do
        expect(total_number_of_visits).to eq(7)
      end
    end
    context 'Show insights for storage values sorted by visits_count' do
      let(:show_storage_visits) { test_storage.show_visits('visits_count') }
      it 'Visits are shown correctly' do
        expect { show_storage_visits }.to output(visits_sorted_by_visits_count_insights).to_stdout
      end
    end
    context 'Show insights for storage values sorted by unique_visitors' do
      let(:show_storage_visits) { test_storage.show_visits('unique_visitors') }
      it 'Visits are shown correctly' do
        expect { show_storage_visits }.to output(visits_sorted_by_unique_visitors_insights).to_stdout
      end
    end
    context 'Show insights for storage values sorted by unimplemented criteria' do
      let(:show_storage_visits) { test_storage.show_visits('url_length') }
      let(:error_message) { "Sorting criteria not recognized\n" }
      it 'Error message shown as expected' do
        expect { show_storage_visits }.to output(a_string_including(error_message)).to_stdout
      end
    end
    context 'Show insights for storage values without sorting criteria' do
      let(:show_storage_visits) { test_storage.show_visits }
      it 'Error is raised as expected' do
        expect { show_storage_visits }.to raise_error(ArgumentError)
      end
    end
  end
end
def test_storage
  storage = VisitsStorage.new
  storage.add_visit('/home', '184.162.53.025')
  storage.add_visit('/home', '184.162.53.025')
  storage.add_visit('/home', '194.162.53.026')
  storage.add_visit('/about', '184.162.53.025')
  storage.add_visit('/about', '184.162.53.025')
  storage.add_visit('/about', '184.162.53.025')
  storage.add_visit('/about', '184.162.53.025')
  storage
end

def faulty_test_storage
  storage = VisitsStorage.new
  storage.add_visit('/home')
end

def visits_sorted_by_unique_visitors_insights
  <<~INFO
    /home visited 3 times by 2 unique visitors
    /about visited 4 times by 1 unique visitors
  INFO
end

def visits_sorted_by_visits_count_insights
  <<~INFO
    /about visited 4 times by 1 unique visitors
    /home visited 3 times by 2 unique visitors
  INFO
end
