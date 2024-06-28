class QuestionDetailsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'question_details'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
