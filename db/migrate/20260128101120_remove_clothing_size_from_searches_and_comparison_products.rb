class RemoveClothingSizeFromSearchesAndComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :searches, :clothing_size, :string
    remove_column :comparison_products, :clothing_size, :string
  end
end
