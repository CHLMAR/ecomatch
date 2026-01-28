module ApplicationHelper
  def saved_to_wishlist?(match)
    return false unless user_signed_in?
    current_user.wishlist_items.exists?(match_id: match.id)
  end

  def wishlist_item_for(match)
    return nil unless user_signed_in?
    current_user.wishlist_items.find_by(match_id: match.id)
  end
end
