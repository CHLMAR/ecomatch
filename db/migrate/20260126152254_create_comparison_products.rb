class CreateComparisonProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :comparison_products do |t|
      t.string :clothing_tim
      t.string :clothing_material
      t.string :clothing_colour
      t.string :clothing_size
      t.string :clothing_brand
      t.float :clothing_price
      t.string :external_link
      t.text :product_description
      t.string :item_image

      t.timestamps
    end
  end
end
