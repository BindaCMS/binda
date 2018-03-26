module Binda
	module FieldableAssociationHelpers

		extend ActiveSupport::Concern

		include FieldableTextHelpers
		include FieldableStringHelpers
		include FieldableImageHelpers
		include FieldableVideoHelpers
		include FieldableAudioHelpers
		include FieldableSvgHelpers
		include FieldableRelationHelpers
		include FieldableSelectionHelpers
		include FieldableRepeaterHelpers
		include FieldableDateHelpers

	end
end