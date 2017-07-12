module Binda
	class Truefalse < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting
  	
	end
end