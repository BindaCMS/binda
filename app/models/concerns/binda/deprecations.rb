Binda::Deprecation
	.new
	.deprecate_methods(
  	Binda::FieldableAssociationHelpers, 
  	get_selection_choice: :get_selection_choices,
  	has_repeater: :has_repeaters,
  	get_repeater: :get_repeaters,
  )