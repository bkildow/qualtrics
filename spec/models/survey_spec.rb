require_relative '../spec_helper'
require_relative '../vcr_helper'

describe Qualtrics::Survey do

  before(:all) do
    VCR.use_cassette('qualtrics_survey') do
      api = Qualtrics::ApiService.new
      @survey_xml = api.get_survey
    end
  end

  it 'should extract multiple question objects' do
    survey = Qualtrics::Survey.new(@survey_xml)
    expect(survey.questions.count).to eq(31)
  end
end
