class CreateBindaTables < ActiveRecord::Migration[5.0]
  def change

    create_table :binda_settings do |t|
    	t.string           :name, null: false
    	t.string           :slug
  		t.index            :slug, unique: true
    	t.text             :content
    	t.integer          :position
    end

    create_table :binda_pages do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.string           :publish_state
      t.integer          :position
      t.belongs_to       :structure
      t.timestamps
    end

    create_table :binda_structures do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.timestamps
    end

    create_table :binda_field_groups do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.text             :description
      t.integer          :position
      t.string           :layout
      t.belongs_to       :structure
      t.timestamps
    end

    create_table :binda_field_settings do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.text             :description
      t.integer          :position
      t.boolean          :required
      t.text             :default_text
      t.string           :field_type
      t.belongs_to       :field_group
      t.timestamps
    end

    create_table :binda_texts do |t|
      t.text             :content
      t.integer          :position
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :binda_categories do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.belongs_to       :structure
      t.timestamps
    end

    create_table :categories_pages, id: false do ||
      t.belongs_to       :category, index: true
      t.belongs_to       :page, index: true
    end

    create_table :friendly_id_slugs do |t|
      t.string           :slug,           :null => false
      t.integer          :sluggable_id,   :null => false
      t.string           :sluggable_type, :limit => 50
      t.string           :scope
      t.datetime         :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type
    
  end
end
