module SelectHelpers
	def select2(value, select_id )
	  first("#select2-#{select_id}-container").click
	  # Capybara sometimes cannot find element in Select2 dropdown saying they aren't visible
	  # To avoid the problem increase the height of the dropdown
	  page.evaluate_script("document.getElementById('select2-#{select_id}-results').style.maxHeight = '10000px';")
	  find(".select2-results__option", text: value).click
	end
end

RSpec.configure do |config|
  config.include SelectHelpers, type: :feature
end