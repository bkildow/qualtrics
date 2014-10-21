# Multiple choice question type
module Qualtrics
  class MCQuestion < Question
    attr_reader :question_text, :question_description, :question_id, :choices

    def parse
      @question_id = @xml_question.search('> ExportTag').first.content
      @question_description = escape @xml_question.search('> QuestionDescription').first.content
      @question_text = @xml_question.search('> QuestionText').first.content
      @choices = {}
      xml_choices = @xml_question.search('Choices > Choice')
      xml_choices.each do |c|
        choice_id = c.attribute('ID').value
        choice_description = c.search('Description').first.content
        @choices[choice_id] = escape choice_description
      end
    end

    def display_question
      @question_description
    end

    def display_answer(response)
      @choices.map do |k, v|
        key = [@question_id, k].join('_')
        v if response[key] === 1
      end.compact.join(', ')
    end

    def export_choices
      @choices.values
    end

    def export_answers(response)
      @choices.map do |k, v|
        key = [@question_id, k].join('_')
        response[key]
      end
    end

  end
end
