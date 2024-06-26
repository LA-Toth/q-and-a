class QuestionStateController < ApplicationController
  def index
    @question_state = Rails.application.config.question_state
  end

  def first_topic
    @question_state = Rails.application.config.question_state
    @question_state.first_topic
  end

  def next_topic
    @question_state = Rails.application.config.question_state
    @question_state.next_topic
  end

  def next_topic_question
    @question_state = Rails.application.config.question_state
    @question_state.next_question
  end

  def next_question
    @question_state = Rails.application.config.question_state
    if Question.exist?(@question_state.topic, @question_state.question + 1)
      @question_state.next_question
    elsif Question.exist?(@question_state.topic + 1, 1)
      @question_state.next_topic
    else
      @question_state.topic = 1000
      @question_state.question = 1000
    end
  end
end
