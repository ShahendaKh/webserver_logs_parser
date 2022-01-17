# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Logs parser script' do
  describe 'Run script with arguments' do
    context 'Given no arguments' do
      let(:run_parser) { system 'ruby logs_parser.rb' }
      let(:error_message) { "ERROR: Please enter log file name saved in data folder or an absolute file path\n" }
      it 'Shows error message and exits' do
        expect { run_parser }.to output(error_message).to_stdout_from_any_process
      end
    end

    context 'Given non-existent file' do
      let(:run_parser) { system 'ruby logs_parser.rb wrong_file.log' }
      let(:error_message) { "ERROR: Log file could not be found\n" }
      it 'Shows error message and exits' do
        expect { run_parser }.to output(error_message).to_stdout_from_any_process
      end
    end

    context 'Given file name existing in data folder' do
      let(:run_parser) { system 'ruby logs_parser.rb webserver.log' }
      it 'Shows error message and exits' do
        expect { run_parser }.to output(parser_insights).to_stdout_from_any_process
      end
    end
  end
end

def parser_insights
  <<~INFO
    total urls visited: 6
    total visits count: 500

    visits sorted by visits count:
    /about/2 visited 90 times by 22 unique visitors
    /contact visited 89 times by 23 unique visitors
    /index visited 82 times by 23 unique visitors
    /about visited 81 times by 21 unique visitors
    /help_page/1 visited 80 times by 23 unique visitors
    /home visited 78 times by 23 unique visitors

    visits sorted by unique visitors:
    /index visited 82 times by 23 unique visitors
    /home visited 78 times by 23 unique visitors
    /contact visited 89 times by 23 unique visitors
    /help_page/1 visited 80 times by 23 unique visitors
    /about/2 visited 90 times by 22 unique visitors
    /about visited 81 times by 21 unique visitors
  INFO
end
