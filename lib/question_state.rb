class QuestionState
  attr_accessor :topic, :question

  def initialize(topic, question)
    @topic = topic
    @question = question
  end

  def next_topic
    @topic += 1
    @question = 1
  end

  def next_question
    @question += 1
  end

  def first_topic
    @topic = 1
    @question = 1
  end
end
