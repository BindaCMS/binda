module SelectHelpers
	def select2(value, id)
	  first("#select2-#{id}-container").click
	  find(".select2-results__option", text: value).click
	end
end

RSpec.configure do |config|
  config.include SelectHelpers, type: :feature
end