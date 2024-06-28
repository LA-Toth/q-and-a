class QuestionStateController < ApplicationController
  before_action :set_question_state

  def index
    set_vars
    render :common
  end

  def first_topic
    @question_state.first_topic
    update_channel_and_redirect
  end

  def next_topic
    if Question.exist?(@question_state.topic + 1, 1)
      @question_state.next_topic
    else
      @question_state.topic = Question::COMPLETED_VALUE
      @question_state.question = Question::COMPLETED_VALUE
    end
    update_channel_and_redirect
  end

  def previous_topic
    if @question_state.topic > 1
      @question_state.topic = Question.previous_topic_of(@question_state.topic)
      @question_state.question = Question.last_question_of(@question_state.topic)
    end
    update_channel_and_redirect
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
    update_channel_and_redirect
  end

  def previous_question
    if @question_state.topic == Question::COMPLETED_VALUE
      @question_state.topic = Question.previous_topic_of(@question_state.topic)
      @question_state.question = Question.last_question_of(@question_state.topic)
    elsif @question_state.question > 1 && Question.exist?(@question_state.topic, @question_state.question - 1)
      @question_state.question -= 1
    elsif @question_state.topic > 1
      @question_state.topic -= 1
      @question_state.question = Question.last_question_of(@question_state.topic)
    else
      @question_state.topic = 1
      @question_state.question = 1
    end
    update_channel_and_redirect
  end

  private

  def set_question_state
    @question_state = Rails.application.config.question_state
  end

  def set_vars
    @question = Question.new
    @next_topic, @next_question = @question.next_topic_and_question
  end

  def update_channel_and_redirect
    ActionCable.server.broadcast("question_details", { topic: @question_state.topic, question: @question_state.question, completed_value: Question::COMPLETED_VALUE })
    if ENV.fetch('USE_HTTP_REDIRECT', '0') == '1'
      redirect_to action: :index, protocol: 'http://'
    else
      redirect_to action: :index
    end
  end
end
