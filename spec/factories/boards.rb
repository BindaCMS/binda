FactoryBot.define do

  # IMPORTANT:
  # if you need to create a board use :board_structure
  # 
  # Boards are automatically generated when you create 
  # a structure with `instance_type` = `board`

	factory :board_structure_with_fields, parent: :board_structure do
    after(:create) do |board_structure, evaluator|
      # Fetch the deafult field group
      field_group = board_structure.field_groups.first
      
      # Generate some field settings
      create :string_setting, field_group: field_group
      create :repeater_setting_with_children_settings, field_group: field_group
    end
  end

end
