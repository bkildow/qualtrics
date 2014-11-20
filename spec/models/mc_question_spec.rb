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
  let (:single_mc_question) { survey.questions.find { |q| q.instance_of? Qualtrics::MCQuestion } }
  let (:multiple_mc_question) do
    survey.questions.find do |q|
      (q.instance_of? Qualtrics::MCQuestion) && q.selector === 'MAVR'
    end
  end

  describe 'selector behavior' do
    it 'should be DL for drop downs' do
      expect(single_mc_question.selector).to eq('DL')
    end

    it 'should be MAVR for multi select' do
      expect(multiple_mc_question.selector).to eq('MAVR')
    end

    it 'should contain certain values' do
      selectors = survey.questions.map do |q|
        q.selector if q.instance_of? Qualtrics::MCQuestion
      end.compact.uniq

      expect(selectors).to eq(%w(DL SAVR MAVR))
    end
  end

  describe '#display_answer' do
    it 'should display a single answer' do
      expect(single_mc_question.display_answer(@response)).to eq('Biomedical Engineering')
    end

    it 'should display multiple answers separated by a comma' do
      expect(multiple_mc_question.display_answer(@response)).to eq('Green, Blue')
    end
  end

  describe '#export_choices' do
    it 'should export single value array' do
      expect(single_mc_question.export_choices).to eq(['Majors'])
    end

    it 'should export multi value array' do
      expect(multiple_mc_question.export_choices).to eq(%w(Red Green Blue))
    end
  end

  describe '#export_answers' do
    it 'should export a single value answer' do
      expect(single_mc_question.export_answers(@response)).to eq(['Biomedical Engineering'])
    end

    it 'should export a multi value answer' do
      expect(multiple_mc_question.export_answers(@response)).to eq(['', 1, 1])
    end

  end

end
