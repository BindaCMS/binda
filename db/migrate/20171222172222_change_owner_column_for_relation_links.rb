class ChangeOwnerColumnForRelationLinks < ActiveRecord::Migration[5.1]
  def change
  	remove_column :binda_relation_links, :owner_type
  end
end
