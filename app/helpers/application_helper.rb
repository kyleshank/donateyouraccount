module ApplicationHelper
  def ul(collection, *args)
    return if collection.empty?
    list_items = ""
    collection.each do |c|
      list_items << "<li>#{c}</li>"
    end
    content_tag :ul, list_items.html_safe, args
  end
end
