# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/services/logs_parser_service'
require_relative '../../../lib/visits_storage'

RSpec.configure do |config|
  config.before(:all) do
    @web_parser
  end
end

RSpec.describe 'Logs parser service' do
  describe 'Parses log file and shows insights' do
    context 'Initialize service with fixtures/webserver.log file' do
      let(:initialize_parser) { LogsParserService.new('spec/fixtures/webserver.log') }
      it 'Initialized successfully' do
        expect(initialize_parser).to(satisfy { |service| service.log_file_lines.length == 5 })
        expect(initialize_parser).to(satisfy { |service| service.visits_storage.total_urls_visited == 0 })
      end
    end

    context 'Parse valid file' do
      let(:parse_valid_file) { LogsParserService.new('spec/fixtures/webserver.log').parse }
      it 'Parsed successfully' do
        expect { parse_valid_file }.to output(valid_file_response).to_stdout
      end
    end

    context 'Parse a file with extra empty line' do
      let(:parse_file_with_invalid_data) { LogsParserService.new('spec/fixtures/webserver_with_empty_line.log').parse }
      let(:error_message) { "WARN: Missing values in row #3. Row is ignored\n" }
      it 'Error message is shown as expected' do
        expect { parse_file_with_invalid_data }.to output(a_string_including(error_message)).to_stdout
      end
    end

    context 'Parse a file with a missing ip in one line' do
      let(:parse_file_with_invalid_data) { LogsParserService.new('spec/fixtures/webserver_with_missing_ip.log').parse }
      let(:error_message) { "WARN: Missing values in row #4. Row is ignored\n" }
      it 'Error message is shown as expected' do
        expect { parse_file_with_invalid_data }.to output(a_string_including(error_message)).to_stdout
      end
    end

    context 'Parse a file with an extra value in one line' do
      let(:parse_file_with_invalid_data) { LogsParserService.new('spec/fixtures/webserver_with_extra_value.log').parse }
      let(:error_message) { "WARN: Extra values in row #3 are ignored\n" }
      it 'Error message is shown as expected' do
        expect { parse_file_with_invalid_data }.to output(a_string_including(error_message)).to_stdout
      end
    end
  end
end

def valid_file_response
  <<~INFO
    total urls visited: 4
    total visits count: 5

    visits sorted by visits count:
    /help_page/1 visited 2 times by 2 unique visitors
    /about/2 visited 1 times by 1 unique visitors
    /home visited 1 times by 1 unique visitors
    /contact visited 1 times by 1 unique visitors

    visits sorted by unique visitors:
    /help_page/1 visited 2 times by 2 unique visitors
    /about/2 visited 1 times by 1 unique visitors
    /home visited 1 times by 1 unique visitors
    /contact visited 1 times by 1 unique visitors
  INFO
end
