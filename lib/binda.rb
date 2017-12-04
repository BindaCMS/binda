require "binda/engine"

module Binda
	# Your code goes here...

  class << self

  	def components structure_slug
  		self::Component.where(structure_id: self::Structure.where(slug: structure_slug))
  	end

  	def boards structure_slug
  		self::Board.where(structure_id: self::Structure.where(slug: structure_slug))
  	end

  end

end