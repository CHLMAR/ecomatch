class AddBrandIdToComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :comparison_products, :brand, null: false, foreign_key: true
  end
end
