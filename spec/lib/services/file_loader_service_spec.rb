# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/services/file_loader_service'

RSpec.describe 'File loader service' do
  describe 'Load file line by line' do
    context 'Given a file name that exists in the data folder' do
      let(:load_file) { FileLoaderService.new('webserver.log') }
      it 'Loaded successfully' do
        expect(load_file).to(satisfy { |value| value.log_file_lines.any? })
      end
    end
    context 'Given a file path that exists' do
      let(:load_file) { FileLoaderService.new('spec/fixtures/webserver.log') }
      it 'Loaded successfully' do
        expect(load_file).to(satisfy { |value| value.log_file_lines.any? })
      end
    end
    context 'Given a file path that does not exist' do
      let(:load_file) { FileLoaderService.new('spec/fixtures/wrong_webserver.log') }
      let(:error_message) { "ERROR: Log file could not be found\n" }
      it 'Loading fails' do
        expect { load_file }.to output(error_message).to_stdout_from_any_process
      end
    end
  end
end
