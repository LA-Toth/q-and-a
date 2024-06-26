require 'question_state'

class String
  def splitlines
    split("\n")
  end
end

Rails.application.config.question_state = QuestionState.new(1, 1)
