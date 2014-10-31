# Drill down question
module Qualtrics
  class DDQuestion < Question
    attr_reader :question_text, :question_description, :question_id, :xml_question

    def parse
      @question_id = @xml_question.search('> ExportTag').first.content
      @question_description = escape @xml_question.search('> QuestionDescription').first.content
      @question_text = @xml_question.search('> QuestionText').first.content
      @answers = {}
      xml_choices = @xml_question.search('Answers > Answer')
      xml_choices.each do |c|
        answer_id = c.attribute('ID').value
        answer_description = c.search('Description').first.content
        @answers[answer_id] = escape answer_description
      end
    end

    def display_question
      @question_description
    end

    def display_answer(response)
      # Gets all the keys for the response
      answer_keys = response.keys.find_all { |k| /#{@question_id}/ =~ k }

      # Uses the largest (last) key that contains all of the drill down info
      response_key = answer_keys.last

      # Grab the numeric answer from the response
      answer_key = response[response_key].to_s

      # This is in the format of Spring ~ 2016. It may make sense to parse this further at some point
      @answers[answer_key]
    end
  end
end
