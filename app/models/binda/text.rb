module Binda
	# This class provides support for storing text. It can be called directly to get texts, 
	#   or referenced to call other classes depending on it that deal differently with text.
	#   
	# Binda uses this class to store complex texts usually with rich HTML features. On the admin panel infact 
	#   this field is represented by a WYSIWYG. But this is just a admin panel convention: the class can infact store 
	#   a simple string of text as well.
  class Text < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting
  	
		validates :fieldable_id, presence: true
		validates :fieldable_type, presence: true
  	
  end
end
