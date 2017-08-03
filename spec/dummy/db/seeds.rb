p "- - - - - - - - - - - - - - - - - -"
p "SEEDING DATABASE"
p "- - - - - - - - - - - - - - - - - -"

dashboard_structure = ::Binda::Structure.find_or_create_by( name: 'dashboard', slug: 'dashboard', instance_type: 'setting' )
unless dashboard_structure.setting.nil?
  @dashboard = dashboard_structure.setting
else
  @dashboard = dashboard_structure.create_setting( name: 'dashboard' )
end

# By default each structure has a field group which will be used to store the default field settings
field_settings = dashboard_structure.field_groups.first.field_settings


# MAINTENANCE MODE
p "Setting up maintenance mode"

# Use radio field_type untill truefalse isn't available
maintenance_mode = field_settings.find_or_create_by( name: 'Maintenance Mode', field_type: 'radio')
maintenance_mode.update_attributes( slug: 'maintenance-mode' )
active   = maintenance_mode.choices.find_or_create_by( label: 'active', value: 'true' )
disabled = maintenance_mode.choices.find_or_create_by( label: 'disabled', value: 'false' )
maintenance_mode.default_choice = disabled
@dashboard.radios.find_or_create_by( field_setting_id: maintenance_mode.id ).choices << maintenance_mode.default_choice


# WEBSITE NAME
p "Setting up website name"

website_name = field_settings.find_or_create_by( name: 'Website Name', field_type: 'string' )
website_name.update_attributes( slug: 'website-name' )
@dashboard.texts.find_or_create_by( field_setting_id: website_name.id ).update_attributes(content: 'MySite' )


# WEBSITE CONTENT
p "Setting up website description"

website_description = field_settings.find_or_create_by( name: 'Website Description', field_type: 'string' )
website_description.update_attributes( slug: 'website-description' )
@dashboard.texts.find_or_create_by( field_setting_id: website_description.id ).update_attributes( content: 'A website about the world' )