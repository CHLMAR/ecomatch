module MatchesHelper
  # Find comparison products that match at least 2 parameters from the search
  def find_matching_products(search, filter_params = {})
    return ComparisonProduct.none unless search

    item = search.clothing_item
    colour = search.clothing_colour
    material = search.clothing_material

    # Get product IDs matching each parameter using pg_search
    item_ids = item.present? ? ComparisonProduct.search_by_item(item).pluck(:id) : []
    colour_ids = colour.present? ? ComparisonProduct.search_by_colour(colour).pluck(:id) : []
    material_ids = material.present? ? ComparisonProduct.search_by_material(material).pluck(:id) : []

    # Find IDs that appear in at least 2 of the result sets
    all_ids = item_ids + colour_ids + material_ids
    matching_ids = all_ids.tally.select { |_id, count| count >= 2 }.keys

    # Build query with matching products
    products = ComparisonProduct.where(id: matching_ids).includes(:brand)

    # Apply dropdown filters
    products = apply_product_filters(products, filter_params)

    products
  end

  def apply_product_filters(products, params)
    if params[:colour].present? && params[:colour] != "All"
      products = products.search_by_colour(params[:colour])
    end

    if params[:material].present? && params[:material] != "All"
      products = products.search_by_material(params[:material])
    end

    if params[:clothing_item].present? && params[:clothing_item] != "All"
      products = products.search_by_item(params[:clothing_item])
    end

    products
  end
end
