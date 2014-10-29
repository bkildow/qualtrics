require 'vcr'
require 'uri'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.filter_sensitive_data('<QUALTRICS_USER_NAME>') { URI.encode_www_form_component ENV['QUALTRICS_USER_NAME'] }
  config.filter_sensitive_data('<QUALTRICS_API_TOKEN>') { ENV['QUALTRICS_API_TOKEN'] }
  config.filter_sensitive_data('<QUALTRICS_SURVEY_ID>') { URI.encode_www_form_component ENV['QUALTRICS_SURVEY_ID'] }
end
