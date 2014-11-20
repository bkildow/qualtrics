require 'base64'

module Qualtrics

  class TokenService

    attr_reader :token_data, :token_query_string

    def initialize(shib, key: ENV['QUALTRICS_SSO_SECRET_KEY'])
      @token_data = {
          id: shib.name_n,
          timestamp: shib.timestamp,
          expiration: shib.expiration,
          firstname: shib.first_name,
          lastname: shib.last_name,
          email: shib.email,
          emplid: shib.emplid
      }

      @token_query_string = to_query(@token_data)
      @key = key

    end

    def get_url(survey_id: '')
      query = to_query({SID: survey_id, ssotoken: generate_token})
      'https://osuengineering.co1.qualtrics.com/SE/?' + query
    end

    def get_test_url
      query = to_query({key: @key, ssotoken: generate_token})
      'https://new.qualtrics.com/ControlPanel/ssoTest.php?' + query
    end

    def generate_token
      hash = generate_hash(@token_query_string)
      token = @token_query_string + '&mac=' + hash
      encrypt(token)
    end

    def generate_hash(value)
      hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('md5'), @key, value)
      Base64.strict_encode64(hash)
    end

    private

    def encrypt(value)
      require 'mcrypt'
      crypto = Mcrypt.new(:rijndael_128, :ecb, @key, nil, :zeros)
      encrypted = crypto.encrypt(value)
      Base64.strict_encode64(encrypted)
    end

    def to_query(args = {})
      args.collect do |k, v|
        "#{k}=#{v}"
      end.compact * '&'
    end

  end
end
