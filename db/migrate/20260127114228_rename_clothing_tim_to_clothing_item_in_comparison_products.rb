class RenameClothingTimToClothingItemInComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :comparison_products, :clothing_tim, :clothing_item
  end
end
