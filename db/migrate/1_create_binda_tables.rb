class CreateBindaTables < ActiveRecord::Migration[5.0]
  def change

    create_table :binda_boards do |t|
    	t.string           :name, null: false
    	t.string           :slug
  		t.index            :slug, unique: true
    	t.integer          :position
      t.belongs_to       :structure
    end

    create_table :binda_components do |t|
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
      t.integer          :position
      t.boolean          :has_categories, default: true
      t.boolean          :has_preview, default: false
      t.index            :slug, unique: true
      t.string           :instance_type, null: false, default: 'component'
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
      t.boolean          :required, default: false
      t.boolean          :read_only, default: false
      t.text             :default_text
      t.string           :field_type
      t.belongs_to       :field_group
      t.string           :ancestry
      t.index            :ancestry
      t.boolean          :allow_null, default: true
      t.references       :default_choice, index: true
      t.timestamps
    end

    create_table :binda_field_settings_structures do |t|
      t.belongs_to :field_setting
      t.belongs_to :structure
    end

    create_table :binda_repeaters do |t|
      t.integer          :position
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :binda_texts do |t|
      t.text             :content
      t.integer          :position
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.string           :type
      t.timestamps
    end

     create_table :binda_galleries do |t|
      t.integer          :position
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :binda_assets do |t|
      t.string           :type
      t.string           :video
      t.string           :image
      t.string           :audio
      t.string           :svg
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.string           :content_type
      t.float            :file_size
      t.float            :file_width
      t.float            :file_height
      t.timestamps
    end

    create_table :binda_dates do |t|
      t.datetime         :date
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :binda_choices do |t|
      t.string           :label
      t.string           :value
      t.belongs_to       :field_setting
      t.timestamps
    end

    create_table :binda_choices_selections do |t|
      t.belongs_to :choice, index: true
      t.belongs_to :selection, index: true
      t.timestamps
    end
    
    create_table :binda_selections do |t|
      t.belongs_to       :field_setting
      t.references       :fieldable, polymorphic: true, index: true
      t.string           :type
      t.timestamps
    end

    create_table :binda_categories do |t|
      t.string           :name, null: false
      t.string           :slug
      t.index            :slug, unique: true
      t.belongs_to       :structure
      t.integer          :position
      t.text             :description
      t.timestamps
    end

    create_table :binda_categories_components, id: false do |t|
      t.belongs_to       :category, index: true
      t.belongs_to       :component, index: true
    end

    create_table :binda_relations do |t|
      t.integer          :field_setting_id
      t.references       :fieldable, polymorphic: true, index: true
    end

    create_table :binda_relation_links do |t|
      t.references       :owner, polymorphic: true, index: true
      t.references       :dependent, polymorphic: true, index: true
      t.timestamps
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

    # DEVISE
    create_table :binda_users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Custom Binda setup
      t.boolean :is_superadmin, default: false

      t.timestamps null: false
    end

    add_index :binda_users, :email,                unique: true
    add_index :binda_users, :reset_password_token, unique: true
    add_index :binda_users, :confirmation_token,   unique: true
    add_index :binda_users, :unlock_token,         unique: true

  end
end
