class AddPreviewMode < ActiveRecord::Migration[5.1]
  def change
  	add_column :binda_structures, :has_preview, :boolean, default: false
  end
end
