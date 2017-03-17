module Binda
  class Text < ApplicationRecord

  	belongs_to :fieldable, polymorphic: true
  	
  end
end
