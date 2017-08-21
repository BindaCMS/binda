class AddDefaultChoiceToBindaChoices < ActiveRecord::Migration[5.1]
  
  def change
    # add_column :binda_choices, :default, :boolean, default: false
    # remove_reference :binda_field_settings, :default_choice, index: true
  end

end
