module Qualtrics
  class Survey

    attr_reader :questions

    def initialize(survey_xml)
      @survey_xml = survey_xml
      @questions = []
      extract_questions
    end

    private

    def extract_questions
      doc = Nokogiri::XML(@survey_xml)

      # Loop over all of the questions
      questions = doc.search('Questions > Question')
      questions.each do |q|

        # get the question type
        qt = q.search('> Type').first.content

        # generate a model based on the question type
        @questions << get_question_model(qt, q)
      end
    end

    def get_question_model(question_type, question)
      class_name = question_type + 'Question'
      klass = class_name.constantize
      klass.new(question)
    end

  end
end
