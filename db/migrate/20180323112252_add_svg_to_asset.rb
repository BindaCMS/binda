class AddSvgToAsset < ActiveRecord::Migration[5.1]
  def change
  	add_column :binda_assets, :svg, :string	
  end
end
