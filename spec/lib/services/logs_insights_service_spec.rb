# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/services/logs_insights_service'
require_relative '../../../lib/visits_storage'
RSpec.describe 'Logs insights service' do
  describe 'Show insights from storage' do
    context 'Given a storage with three entries' do
      let(:show_insights) { LogsInsightsService.new(test_visits_storage).show_insights }
      let(:insights) { example_one_output }
      it 'Shown successfully' do
        expect { show_insights }.to output(insights).to_stdout
      end
    end
    context 'Given an empty storage' do
      let(:show_insights) { LogsInsightsService.new(VisitsStorage.new).show_insights }
      let(:insights) { example_two_output }
      it 'Nothing is shown' do
        expect { show_insights }.to output(insights).to_stdout
      end
    end
  end
end
def example_one_output
  <<~INFO
    total urls visited: 2
    total visits count: 3
    visits sorted by visits count:
    /home visited 2 times by 2 unique visitors
    /about visited 1 times by 1 unique visitors
    visits sorted by unique visitors:
    /home visited 2 times by 2 unique visitors
    /about visited 1 times by 1 unique visitors
  INFO
end

def example_two_output
  <<~INFO
    total urls visited: 0
    total visits count: 0
    visits sorted by visits count:
    visits sorted by unique visitors:
  INFO
end

def test_visits_storage
  visits_storage = VisitsStorage.new
  visits_storage.add_visit('/home', '184.123.665.067')
  visits_storage.add_visit('/about', '184.123.665.067')
  visits_storage.add_visit('/home', '184.123.665.068')
  visits_storage
end
