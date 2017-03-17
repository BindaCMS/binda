class CreateBindaTables < ActiveRecord::Migration[5.0]
  def change

    create_table :binda_pages do |t|
    	t.string           :name, null: false
    	t.string           :slug
  		t.index            :slug, unique: true
    	t.string           :publish_state
      t.timestamps
    end

    create_table :binda_settings do |t|
    	t.string           :name, null: false
    	t.string           :slug
  		t.index            :slug, unique: true
    	t.string           :content
    	t.integer          :position
    end

    create_table :friendly_id_slugs do |t|
      t.string   :slug,           :null => false
      t.integer  :sluggable_id,   :null => false
      t.string   :sluggable_type, :limit => 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type
    
  end
end
