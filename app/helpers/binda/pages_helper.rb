module Binda
  module PagesHelper

  	def get_text( page, field_setting )
			page.texts.where( field_setting: field_setting ).first.content unless page.texts.where( field_setting: field_setting ).first.nil?
  	end

  end
end
