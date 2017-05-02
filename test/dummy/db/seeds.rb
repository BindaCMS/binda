p "- - - - - - - - - - - - - - - - - -"
p "SEEDING DATABASE"
p "- - - - - - - - - - - - - - - - - -"


p "Setting up defaults"

# MAINTENANCE MODE
Binda::Setting.find_or_create_by( name: 'Maintenance Mode' )

# WEBSITE NAME
unless Binda::Setting.where(slug: 'website-name').present?
	Binda::Setting.create({ name: 'Website Name', content: 'My App'})
end

# WEBSITE CONTENT
unless Binda::Setting.where(slug: 'website-description').present?
	Binda::Setting.create({ name: 'Website Description', content: 'Hello world'})
end

# p "Creating Structures"

# static_component_structure = Binda::Structure.create({ name: 'Static Component' })
# project_structure     = Binda::Structure.create({ name: 'Project' })
# contact_structure     = Binda::Structure.create({ name: 'Contact' })


# # - - - - - - - - - - - - - - - - - - - -


# p "Creating Field Groups"

# default_group = Binda::FieldGroup.create({ name: 'default' })
# contact_group = Binda::FieldGroup.create({ name: 'contact' })


# # - - - - - - - - - - - - - - - - - - - -


# p "Creating Field Settings"

# # Default
# main_content = default_group.field_settings.create({ name: 'Main Content', field_type: 'text' })
# project_structure.field_groups << default_group
# contact_structure.field_groups << default_group

# # Contact
# address  = contact_group.field_settings.create({ name: 'Address', field_type: 'text' })
# phone    = contact_group.field_settings.create({ name: 'Phone', field_type: 'text' })
# mail     = contact_group.field_settings.create({ name: 'Mail', field_type: 'text' })
# contact_structure.field_groups << contact_group


# # - - - - - - - - - - - - - - - - - - - -


# p "Creating Categories"

# for i in 1..4
# 	category = Binda::Category.create({ 
# 		name: FFaker::CheesyLingo.word,
# 		structure_id: project_structure.id
# 	})
# end


# # - - - - - - - - - - - - - - - - - - - -


# p "Creating Components"

# # Static Components
# for i in 1..6
# 	component = Binda::Component.create({
# 		name:             FFaker::CheesyLingo.title,
# 		structure_id:     static_component_structure.id
# 	})
# 	component.categories << Binda::Category.find( rand(1..4) )
# 	component.texts.create({ 
# 		content:          FFaker::CheesyLingo.paragraph,
# 		field_setting_id: main_content.id
# 	})
# 	component.publish! unless i%3 == 0
# end

# # Contact Components
# for i in 1..4
# 	component = Binda::Component.create({
# 		name:             FFaker::CheesyLingo.title,
# 		structure_id:     contact_structure.id
# 	})
# 	component.texts.create({ 
# 		content:          FFaker::CheesyLingo.paragraph,
# 		field_setting_id: address.id
# 	})
# 	component.texts.create({ 
# 		content:          FFaker::PhoneNumber.phone_number,
# 		field_setting_id: phone.id
# 	})
# 	component.texts.create({ 
# 		content:          "#{ FFaker::CheesyLingo.word }@#{ FFaker::CheesyLingo.word }.com",
# 		field_setting_id: mail.id
# 	})
# 	component.publish! unless i%3 == 0
# end


# # - - - - - - - - - - - - - - - - - - - -


# p "- - - - - - - - - - - - - - - - - -"