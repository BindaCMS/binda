Binda::Deprecation
	.new
	.deprecate_methods(
  	Binda::FieldableAssociations, 
  	get_selection_choice: :get_selection_choices
  )