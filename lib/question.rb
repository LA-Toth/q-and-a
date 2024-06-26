class Question < QuestionState
  def initialize
    st = Rails.application.config.question_state
    super(st.topic, st.question)
  end

  def text
    @text || load_question
  end

  def load_question
    filename = Rails.root.join(format('topics-questions/%02d-%02d.txt', topic, question))
    @text = File.exist?(filename) ? File.read(filename) : '<missing question>'
  end

  def self.exist?(topic, question)
    File.exist? Rails.root.join(format('topics-questions/%02d-%02d.txt', topic, question))
  end
end
