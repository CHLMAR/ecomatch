class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uploaded_image
      t.string :uploaded_link
      t.string :system_prompt
      t.string :clothing_item
      t.string :clothing_material
      t.string :clothing_colour
      t.string :clothing_size
      t.string :clothing_brand
      t.float :clothing_price
      t.string :item_image
      t.string :item_name
      t.text :item_description
      t.string :url

      t.timestamps
    end
  end
end
