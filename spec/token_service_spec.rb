require 'spec_helper'

describe Qualtrics::TokenService do

  let(:shib) { build(:shibboleth) }
  let(:token_service) { Qualtrics::TokenService.new(shib, key: '1234567890123456') }

  describe '#generate_hash' do
    it 'should generate the correct hash' do
      tqs = token_service.token_query_string
      expect(token_service.generate_hash(tqs)).to eq('MSDWUODlc+853pnCHp1KAw==')
    end
  end

  describe '#token_query_string' do
    it 'should be a query string' do
      qs = 'id=buckeye.1&timestamp=2014-09-11T15:33:48&expiration=2014-09-11T15:33:48&firstname=Brutus&lastname=Buckeye&email=buckeye.1@osu.edu&emplid=111111111'
      expect(token_service.token_query_string).to eq(qs)
    end
  end

  describe '#generate_token' do
    it 'should generate the correct token' do
      token = token_service.generate_token

      # this is zero padded, but qualtrics will correctly read this even though it varies slightly from their test page
      correct_token = 'B994eisKkGiBkrv7tNGqFfmG3Y7txiG0ZDAJ3CdinBa8hXqEJA4/3nUeTQ6G25l0s05lm9ZNfkvcWmHe37Sf+qKNbGXp60Xl55Bhc3fd1RYQ4QG9B/SfjKviybWQxXElCaCexf4/j/vIB4b8Oq+u3CdLdpgjT53QSp8m9s9BP4maZ4SH7rwUSeja9wTWtphNIbFi8j/uwPuwLDy+5B2JQZq78kRwX6OyY8xQ2udKEziyccvq+kmXPMCyZ8mdzHWp'
      expect(token).to eq(correct_token)
    end
  end

end
