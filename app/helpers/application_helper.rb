module ApplicationHelper
  def saved_to_wishlist?(match)
    return false unless user_signed_in?
    current_user.wishlist_items.exists?(match_id: match.id)
  end
end
