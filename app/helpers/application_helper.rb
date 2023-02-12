module ApplicationHelper
  def remove_underscore(text)
    text&.gsub('_', ' ')&.gsub('\bor', '/')
  end
end
