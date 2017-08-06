class CreateBindaSelections < ActiveRecord::Migration[5.1]
  def change
    create_table :binda_choices_selects do |t|
    	t.belongs_to :choice, index: true
    	t.belongs_to :select, index: true
      t.timestamps
    end
    change_table :binda_choices do |t|
	    t.remove_references :selectable, :polymorphic => true
	  end
  end
end
