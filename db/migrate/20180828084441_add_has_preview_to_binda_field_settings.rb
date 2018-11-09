class AddHasPreviewToBindaFieldSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :binda_field_settings, :has_preview, :boolean, default: false
  end
end
