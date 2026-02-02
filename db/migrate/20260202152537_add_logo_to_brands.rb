class AddLogoToBrands < ActiveRecord::Migration[7.1]
  def change
    add_column :brands, :logo, :string
  end
end
