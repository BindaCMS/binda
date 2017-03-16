class CreateBindaPages < ActiveRecord::Migration[5.0]
  def change
    create_table :binda_pages do |t|

    	t.string           :name, null: false
    	t.string           :slug
  		t.index            :slug, unique: true
    	t.string           :publish_state

      t.timestamps
    end
  end
end
