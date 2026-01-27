class RemoveItemNameFromComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :comparison_products, :clothing_tim, :string
  end
end
