module Binda
	# Assets is a parent class which isn't directly used but can be referenced to gather 
	# all the classes that deal with files.
  class Asset < ApplicationRecord

  	include Fields

  end
end