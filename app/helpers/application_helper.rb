module ApplicationHelper
  def escape(text)
    raw h(text).splitlines.join('<br/>')
  end
end
