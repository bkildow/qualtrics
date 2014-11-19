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
  let (:mc_question) { survey.questions.find { |q| q.instance_of? Qualtrics::MCQuestion } }

  describe 'selectors' do
    it 'should get dl' do
      expect(mc_question.selector).to eq('DL')
    end
  end

  describe '#display_answer' do
    it 'should display a single answer' do
      expect(mc_question.display_answer(@response)).to eq('Biomedical Engineering')
    end
  end

  describe '#export_choices' do
    it 'should export single value array' do
      expect(mc_question.export_choices).to eq(['Majors'])
    end
  end

  describe '#export_answers' do
    it 'should export a single value answer' do
      expect(mc_question.export_answers(@response)).to eq(['Biomedical Engineering'])
    end
  end

  describe 'Multiple choice instance' do
    it 'should return an instance with multiple choice' do
      mc_question = survey.questions.each do |q|
        if q.instance_of? Qualtrics::MCQuestion
          return q if q.selector == 'MA'
        end
      end

      expect(mc_question).to eq('MA')
    end
  end

end
