require_relative '../spec_helper'
require_relative '../vcr_helper'

describe Qualtrics::DDQuestion do

  before(:all) do
    VCR.use_cassette('qualtrics_survey') do
      @api = Qualtrics::ApiService.new
      @survey_xml = @api.get_survey
    end

    VCR.use_cassette('qualtrics_response') do
      @response = @api.get_response('R_6Fr1NoQJZRqsfBP')
    end
  end

  let (:survey) { Qualtrics::Survey.new(@survey_xml) }
  let (:dd_question) { survey.questions.find {|q| q.instance_of? Qualtrics::DDQuestion} }

  it 'should display the correct question' do
    expect(dd_question.display_question).to eq('Expected semester of graduation')
  end

  it 'should allow access to the question id' do
    expect(dd_question.question_id).to eq('Q5')
  end

  it 'should display the correctly given a response' do
    expect(dd_question.display_answer(@response)).to eq('Spring ~ 2016')
  end
end
