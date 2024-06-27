class QuestionStateController < ApplicationController
  before_action :set_question_state

  def index
    set_vars
    render :common
  end

  def first_topic
    @question_state.first_topic
    redirect_to action: :index
  end

  def next_topic
    @question_state.next_topic
    redirect_to action: :index
  end

  def next_topic_question
    @question_state.next_question
    redirect_to action: :index
  end

  def next_question
    if Question.exist?(@question_state.topic, @question_state.question + 1)
      @question_state.next_question
    elsif Question.exist?(@question_state.topic + 1, 1)
      @question_state.next_topic
    else
      @question_state.topic = Question::COMPLETED_VALUE
      @question_state.question = Question::COMPLETED_VALUE
    end
    redirect_to action: :index
  end

  private

  def set_question_state
    @question_state = Rails.application.config.question_state
  end

  def set_vars
    @question = Question.new
    @next_topic, @next_question = @question.next_topic_and_question
  end
end
