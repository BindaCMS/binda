require 'pry'

class ReadOnlyValidator < ActiveModel::Validator
	def validate(record)
=begin
	binding.pry
=end
=begin
	get field setting of current record
	return false if field setting has been set to read only
	else true
=end

=begin
		!record.read_only?
=end
	end
end

module Binda
	# Fieldable associated are Binda's core fields. 
	# 
	# They are associated to classes like `Binda::Component` and `Binda::Board` and store data 
	# 	in a simple yet powerful way. 
	module Fields

		extend ActiveSupport::Concern

		included do
	  	# Associations
	  	belongs_to :fieldable, polymorphic: true
	  	belongs_to :field_setting
	  	
	  	validates :field_setting, presence: true
			validates :fieldable_id, presence: true
			validates :fieldable_type, presence: true
			include ActiveModel::Validations
			validates_with ReadOnlyValidator
		end
	end
end



