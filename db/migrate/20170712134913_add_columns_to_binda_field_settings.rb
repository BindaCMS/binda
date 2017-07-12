  class AddColumnsToBindaFieldSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :binda_field_settings, :choices, :text
    add_column :binda_field_settings, :default_choice, :text
    add_column :binda_field_settings, :allow_null, :boolean
    add_column :binda_field_settings, :boolean_choices, :boolean
    add_column :binda_texts, :type, :string

    create_table :binda_truefalses do |t|
      t.boolean          :is_true, default: false
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
