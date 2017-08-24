FactoryGirl.define do

	# Boards are automatically generated when you create 
	# a structure with `instance_type` = `board`
	factory :board_structure, class: Binda::Structure do
    sequence(:name) { |n| "##{n} board" }
    slug { "#{name}".parameterize }
    instance_type 'board'
	end

	factory :board_structure_with_fields, parent: :board_structure do
    transient do
      _count 3
    end
    after(:create) do |board_structure, evaluator|
      # fetch the deafult field group
      field_group = board_structure.field_groups.first
      # Generate some field settings
      create :string_setting, field_group: field_group
      create :repeater_setting_with_fields, field_group: field_group
      string_setting = field_group.field_settings.find{ |fs| fs.field_type == 'string' }
      repeater_setting = field_group.field_settings.find{ |fs| fs.field_type == 'repeater' }
      # create some data
      create_list( :repeater_with_fields, evaluator._count, fieldable: board_structure.board, field_setting: repeater_setting )
      create_list( :string, evaluator._count, fieldable: board_structure.board, field_setting: string_setting )
    end
  end

end