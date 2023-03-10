module ApplicationHelper
  include Pagy::Frontend
  def remove_underscore(text)
    text&.gsub('_', ' ')&.gsub('\bor', '/')
  end

  def coalesce(value, ret = '-')
    value.nil? ? ret : value
  end


  def inline_error_for(field, form_obj)
    html = []
    if form_obj.errors[field].any?
      html << form_obj.errors[field].map do |msg|
        tag.div(msg, class: "text-red-400 text-xs m-0 p-0 text-right mb-2")
      end
    end
    html.join.html_safe
  end

  def sort_link_to(name, column, **options)
    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"
    else
      direction = "asc"
    end

    link_to name, request.params.merge(sort: column, direction: direction), **options
  end
end
