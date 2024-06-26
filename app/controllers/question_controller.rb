class QuestionController < ApplicationController
  def index
    @question = Question.new
  end
end
