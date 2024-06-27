class Question < QuestionState
  COMPLETED_VALUE = 1000
  MISSING_QUESTION = '<missing question>'
  MISSING_ANSWER = '<missing answer>'

  BASE_DIR = ENV.fetch('TOPICS_QUESTIONS_DIR', Rails.root.join('topics-questions'))

  def initialize
    st = Rails.application.config.question_state
    super(st.topic, st.question)
  end

  def text
    @text || load_question
  end

  def answer
    @answer || load_answer
  end

  def load_question
    filename = format('%s/%02d-%02d.txt', BASE_DIR, topic, question)
    @text = File.exist?(filename) ? File.read(filename) : MISSING_QUESTION
  end

  def load_answer
    filename = format('%s/%02d-%02d-answer.txt', BASE_DIR, topic, question)
    @answer = File.exist?(filename) ? File.read(filename) : MISSING_ANSWER
  end

  def self.exist?(topic, question)
    File.exist? format('%s/%02d-%02d.txt', BASE_DIR, topic, question)
  end

  def self.last_question_of(topic)
    99.downto(1).each do |q|
      return q if exist?(topic, q)
    end
  end

  def next_topic_and_question
    if Question.exist?(topic, question + 1)
      [topic, question + 1]
    elsif Question.exist?(topic + 1, 1)
      [topic + 1, 1]
    else
      [COMPLETED_VALUE, COMPLETED_VALUE]
    end
  end
end
