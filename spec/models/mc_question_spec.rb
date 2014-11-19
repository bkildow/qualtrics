require_relative '../spec_helper'
require_relative '../vcr_helper'

describe Qualtrics::MCQuestion do

  before(:all) do
    VCR.use_cassette('qualtrics_survey') do
      @api = Qualtrics::ApiService.new
      @survey_xml = @api.get_survey
    end

    VCR.use_cassette('qualtrics_response_with_multiple_choice') do
      @response = @api.get_response('R_1HUQdzApaGnGoRL')
    end
  end

  let (:survey) { Qualtrics::Survey.new(@survey_xml) }
  let (:mc_question) { survey.questions.find {|q| q.instance_of? Qualtrics::MCQuestion} }

  describe 'selectors' do
    it 'should get dl' do
      expect(mc_question.selector).to eq('DL')
    end
  end

  describe 'survey questions' do
    it 'should '
  end

end
