class AddClothingItemToComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :comparison_products, :clothing_item, :string
  end
end
