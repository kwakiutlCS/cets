module ApplicationHelper
   # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Cets"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  def isAdmin?
    return current_user.admin
  end
end
