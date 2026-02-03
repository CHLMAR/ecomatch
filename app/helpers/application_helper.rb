module ApplicationHelper
  def saved_to_wishlist?(comparison_product)
    return false unless user_signed_in?
    current_user.wishlist_items.exists?(comparison_product_id: comparison_product.id)
  end

  def wishlist_item_for(comparison_product)
    return nil unless user_signed_in?
    current_user.wishlist_items.find_by(comparison_product_id: comparison_product.id)
  end

  def brand_logo(brand_name)
    logos = {
      "Etiko" => "etikoshop_logo.png",
      "EcoWear" => "ecowear.webp",
      "Patagonia" => "Patagonia_Logo.png",
      "Kotn" => "KOTN.png",
      "MUD Jeans" => "Mud_Jeans_Logo.png",
      "Uniqlo" => "UNIQLO_logo.svg.png",
      "ASKET" => "ASKET_logo.png"
    }
    logos[brand_name]
  end
end
