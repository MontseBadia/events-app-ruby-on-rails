module ApplicationHelper
  def page_title
    if content_for?(:title)
      "Events - #{content_for(:title)}"
    else
      "Events"
    end
  end

  def nav_link_to(text, url)
    classes = ['button']
    classes << 'active' if current_page?(url)
    link_to(text, url, class: classes.join(' '))
  end
end
