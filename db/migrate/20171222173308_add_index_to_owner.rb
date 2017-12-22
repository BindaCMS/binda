class AddIndexToOwner < ActiveRecord::Migration[5.1]
  def change
  	add_index :binda_relation_links, :owner_id
  end
end
