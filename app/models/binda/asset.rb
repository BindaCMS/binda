module Binda
  class Asset < ApplicationRecord

  	# Associations
  	has_many :bindings
  	has_many :galleries, through: :bindings
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting

  end
end
