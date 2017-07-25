  class AddColumnsToBindaFieldSettings < ActiveRecord::Migration[5.1]
  def change
    add_column        :binda_field_settings,   :allow_null, :boolean
    add_column        :binda_texts,            :type, :string
    add_reference     :binda_field_settings,   :default_choice, index: true

    create_table :binda_choices do |t|
      t.string           :label
      t.string           :value
      t.belongs_to       :field_setting
      t.references       :selectable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :binda_selects do |t|
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.string           :type
      t.timestamps
    end
  end
end
