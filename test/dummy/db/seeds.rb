p "- - - - - - - - - - - - - - - - - -"
p "SEEDING DATABASE"
p "- - - - - - - - - - - - - - - - - -"


p "Creating Structures"

static_page_structure = Binda::Structure.create({ name: 'Static Page' })
project_structure     = Binda::Structure.create({ name: 'Project' })
contact_structure     = Binda::Structure.create({ name: 'Contact' })


# - - - - - - - - - - - - - - - - - - - -


p "Creating Field Groups"

default_group = Binda::FieldGroup.create({ name: 'default' })
contact_group = Binda::FieldGroup.create({ name: 'contact' })


# - - - - - - - - - - - - - - - - - - - -


p "Creating Field Settings"

# Default
main_content = default_group.field_settings.create({ name: 'Main Content' })
project_structure.field_groups << default_group
contact_structure.field_groups << default_group

# Contact
address  = contact_group.field_settings.create({ name: 'Address' })
phone    = contact_group.field_settings.create({ name: 'Phone' })
mail     = contact_group.field_settings.create({ name: 'Mail' })
contact_structure.field_groups << contact_group


# - - - - - - - - - - - - - - - - - - - -


p "Creating Categories"

for i in 1..4
	category = Binda::Category.create({ 
		name: FFaker::CheesyLingo.word,
		structure_id: project_structure.id
	})
end


# - - - - - - - - - - - - - - - - - - - -


p "Creating Pages"

# Static Pages
for i in 1..6
	page = Binda::Page.create({
		name:             FFaker::CheesyLingo.title,
		structure_id:     static_page_structure.id
	})
	page.categories << Binda::Category.find( rand(1..4) )
	page.texts.create({ 
		content:          FFaker::CheesyLingo.paragraph,
		field_setting_id: main_content.id
	})
	page.publish! unless i%3 == 0
end

# Contact Pages
for i in 1..4
	page = Binda::Page.create({
		name:             FFaker::CheesyLingo.title,
		structure_id:     contact_structure.id
	})
	page.texts.create({ 
		content:          FFaker::CheesyLingo.paragraph,
		field_setting_id: address.id
	})
	page.texts.create({ 
		content:          FFaker::PhoneNumber.phone_number,
		field_setting_id: phone.id
	})
	page.texts.create({ 
		content:          "#{ FFaker::CheesyLingo.word }@#{ FFaker::CheesyLingo.word }.com",
		field_setting_id: mail.id
	})
	page.publish! unless i%3 == 0
end


# - - - - - - - - - - - - - - - - - - - -


p "- - - - - - - - - - - - - - - - - -"