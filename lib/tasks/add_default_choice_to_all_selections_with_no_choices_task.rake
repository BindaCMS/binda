namespace :binda do
	desc "Fix Binda::Selection records that has no choice selected but where their field setting requires at least one."
	task :add_default_choice_to_all_selections_with_no_choices => :environment do
		Binda::Selection.add_default_choice_to_all_selections_with_no_choices
	end
end