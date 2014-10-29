require 'faraday'

module Qualtrics

  class ApiService

    attr_reader :last_response

    def initialize
      @conn = Faraday.new(url: 'https://survey.qualtrics.com') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        # faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end

      @options = {
          User: ENV['QUALTRICS_USER_NAME'],
          Token: ENV['QUALTRICS_API_TOKEN'],
          SurveyID: ENV['QUALTRICS_SURVEY_ID'],
          Version: '2.3',
          Request: 'getLegacyResponseData',
          Format: 'JSON'}
    end

    def get_responses
      @last_response = @conn.get 'WRAPI/ControlPanel/api.php', @options
      JSON.parse(@last_response.body)
    end

    # Get a single survey response from a response id
    def get_response(response_id)
      ws_options = {ResponseID: response_id}
      @last_response = @conn.get 'WRAPI/ControlPanel/api.php', @options.merge(ws_options)
      res = JSON.parse(@last_response.body)
      raise 'Did not receive a valid response from Qualtrics' if res.empty?

      res[response_id]
    end

    def get_survey
      ws_options = {Request: 'getSurvey'}
      @last_response = @conn.get 'WRAPI/ControlPanel/api.php', @options.merge(ws_options)
      @last_response.body
    end

    def add_recipient(first_name:, last_name:, email:)
      ws_options = {
          Request: 'addRecipient',
          LibraryID: ENV['QUALTRICS_LIBRARY_ID'],
          PanelID: ENV['QUALTRICS_PANEL_ID'],
          FirstName: first_name,
          LastName: last_name,
          Email: email
      }

      response = @conn.get 'WRAPI/ControlPanel/api.php', @options.merge(ws_options)
      res = JSON.parse(response.body)

      # return the recipient id or nil if it failed
      result = res['Result'].nil? ? nil : res['Result']['RecipientID']

      if result.nil?
        Rails.logger.info "ERROR: #{first_name} #{last_name} (#{email}) was not added to the Qualtrics panel."
      else
        Rails.logger.info "SUCCESS: #{first_name} #{last_name} (#{email}) was added to the Qualtrics panel."
      end

      result
    end

  end
end
