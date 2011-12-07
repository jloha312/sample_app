module ApplicationHelper
  
  # Return a logo
  def logo
    logo = image_tag("grademypitch300pxBeta.png", :alt => "Grademypitch", :class => "round")
  	
  end
  
  
  # Return a title on a per-page basis.
  def title
    # Sets the browser title bar display
    base_title = "Grademypitch"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
      
end
