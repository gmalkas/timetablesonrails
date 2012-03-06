module ApplicationHelper
	def title(*titles)
    content_for(:title) { h titles.join(" - ") }
	end
end
