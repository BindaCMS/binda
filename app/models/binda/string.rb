module Binda
	# This class depends on `Binda::Text` and it's use mainly to differentiate the type of text 
	#   this class is responsible for.
	# 
	# Binda uses this class to store plain text. The field responsible to store `Binda::String` instances is `type="string"`.
	class String < Text
	end
end