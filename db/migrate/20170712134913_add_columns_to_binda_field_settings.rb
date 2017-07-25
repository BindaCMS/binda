  class AddColumnsToBindaFieldSettings < ActiveRecord::Migration[5.1]
  def change
    add_column        :binda_field_settings,   :allow_null, :boolean
    add_column        :binda_texts,            :type, :string
    add_reference     :binda_field_settings,   :default_choice, index: true

    create_table :binda_choices do |t|
      t.string           :label
      t.string           :content
      t.belongs_to       :field_setting
      t.timestamps
    end
  end
end
