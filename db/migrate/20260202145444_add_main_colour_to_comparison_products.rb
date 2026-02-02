class AddMainColourToComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :comparison_products, :main_colour, :string
  end
end
