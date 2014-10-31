require 'nokogiri'

module Qualtrics
  class Question
    def initialize(question)
      @xml_question = question
      parse
    end

    def parse
      # raise 'this method should be overridden to parse the xml for the question type'
    end

    def display_question
      ''
    end

    def display_answer(response)
      ''
    end

    def escape(string)
      string.gsub(/\n/, ' ').strip if string.is_a? String
    end

  end
end
