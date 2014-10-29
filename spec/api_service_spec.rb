require 'spec_helper'
require 'vcr_helper'

describe Qualtrics::ApiService do

  let(:api) { Qualtrics::ApiService.new }

  describe '#get_survey' do
    it 'should return a 200 status' do
      VCR.use_cassette('qualtrics_survey') do
        api.get_survey
        expect(api.last_response.status).to eq(200)
      end
    end

    it 'should get an xml representation of the survey' do
      VCR.use_cassette('qualtrics_survey') do
        survey = api.get_survey
        expect(survey).to match /Current Engineering Student Scholarship Application/
      end
    end
  end

  describe '#get_responses' do
    it 'should return a 200 status' do
      VCR.use_cassette('qualtrics_responses') do
        api.get_responses
        expect(api.last_response.status).to eq(200)
      end
    end

    it 'should get all responses' do
      VCR.use_cassette('qualtrics_responses') do
        responses = api.get_responses
        expect(responses['R_6Fr1NoQJZRqsfBP']['Q3']).to eq('buckeye.1@osu.edu')
        expect(responses['R_0ILP6GWlqyJNXSZ']['Q3']).to eq('test.1000@osu.edu')
      end
    end
  end

  describe '#get_response' do
    it 'should return a 200 status' do
      VCR.use_cassette('qualtrics_response') do
        api.get_response('R_6Fr1NoQJZRqsfBP')
        expect(api.last_response.status).to eq(200)
      end
    end

    it 'should get a response body' do
      VCR.use_cassette('qualtrics_response') do
        response = api.get_response('R_6Fr1NoQJZRqsfBP')
        expect(response['Q3']).to eq ('buckeye.1@osu.edu')
      end
    end
  end

end
