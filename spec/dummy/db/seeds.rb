puts "- - - - - - - - - - - - - - - - - -"
puts "SEEDING DATABASE"
puts "- - - - - - - - - - - - - - - - - -"

dashboard_structure = Binda::Structure.create( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
@dashboard = dashboard_structure.board
# By default each structure has a field group which will be used to store the default field settings
field_settings = dashboard_structure.field_groups.first.field_settings


# MAINTENANCE MODE
puts "Setting up maintenance mode"

# Use radio field_type untill truefalse isn't available
maintenance_mode = field_settings.create( name: 'Maintenance Mode', field_type: 'radio')
maintenance_mode.update_attributes( slug: 'maintenance-mode' )
disabled = maintenance_mode.choices.create( label: 'disabled', value: 'false' )
active   = maintenance_mode.choices.create( label: 'active', value: 'true' )


# WEBSITE NAME
puts "Setting up website name"

website_name = field_settings.create( name: 'Website Name', field_type: 'string' )
website_name.update_attributes( slug: 'website-name' )
@dashboard.strings.create( field_setting_id: website_name.id ).update_attributes(content: 'MySite' )


# WEBSITE CONTENT
puts "Setting up website description"

website_description = field_settings.create( name: 'Website Description', field_type: 'string' )
website_description.update_attributes( slug: 'website-description' )
@dashboard.texts.create( field_setting_id: website_description.id ).update_attributes( content: 'A website about the world' )