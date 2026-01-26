class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :search, null: false, foreign_key: true
      t.references :comparison_product, null: false, foreign_key: true
      t.text :similarities, null: false

      t.timestamps null: false
    end

    add_index :matches, :search_id
    add_index :matches, :comparison_product_id
  end
end
