# # @see https://gist.github.com/pacoguzman/4056129
# # In order to work you need to make sure items are displayed withing the viewport
# # if not scroll to the target position (make sure source is still on viewport)
# module SortableHelpers
# 	def drag_to(source, target)
# 	  builder = page.driver.browser.action
	  
# 	  source = source.native
# 	  target = target.native
	  
# 	  builder.moveToElement(target).perform
# 	  builder.click_and_hold source
# 	  # builder.move_to        target, 1, 11
# 	  builder.move_to        target
# 	  builder.release
# 	  builder.perform
# 	end
# end

# RSpec.configure do |config|
#   config.include SortableHelpers, type: :feature
# end