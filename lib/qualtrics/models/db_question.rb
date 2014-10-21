# Descriptive text
module Qualtrics
  class DBQuestion < Question
    attr_reader :question_text, :question_description, :question_id

    def parse
      @question_id = @xml_question.search('> ExportTag').first.content
      @question_description = escape @xml_question.search('> QuestionDescription').first.content
      @question_text = @xml_question.search('> QuestionText').first.content
    end

    def display_question
      @question_description
    end

    def display_answer(response)
      ''
    end
  end
end
