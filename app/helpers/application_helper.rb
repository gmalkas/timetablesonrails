##
#
# = ApplicationHelper
#
# Defines a helper to handle titles.
#
module ApplicationHelper
  
  ##
  # 
  # Defines the current page's title.
  #
	def title(*titles)
    content_for(:title) { h titles.join(" - ") }
	end
end
