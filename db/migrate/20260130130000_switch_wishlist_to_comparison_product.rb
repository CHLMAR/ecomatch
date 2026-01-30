class SwitchWishlistToComparisonProduct < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :wishlist_items, :matches
    remove_reference :wishlist_items, :match, index: true

    add_index :wishlist_items, [:user_id, :comparison_product_id], unique: true
  end
end
