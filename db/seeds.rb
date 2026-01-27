# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.last

user.save!
puts "Created user: #{user.email} with password: #{user.password}"
# serach seed with a zara example product
search = Search.new(
  user: user,
  uploaded_image: nil,
  uploaded_link: "https://www.zara.com/fr/en/fine-strap-polyamide-t-shirt-p03905532.html?v1=515205302&v2=2420417",
  system_prompt: "PLACEHOLDER_PROMPT",
  clothing_item: "T-shirt",
  clothing_material: "Poluyamide",
  clothing_colour: "Black",
  clothing_size: "M",
  clothing_brand: "Zara",
  clothing_price: 12.99,
  item_image: "https://static.zara.net/photos///2023/V/0/1/p/3905/532/800/2/w/560/3905532800_2_1_1.jpg?ts=1682616879533",
  item_name: "Fine Strap Polyamide T-Shirt",
  item_description: "Basic black T-shirt from Zara made of polyamide.",
  url: "https://www.zara.com/fr/en/fine-strap-polyamide-t-shirt-p03905532.html?v1=515205302&v2=2420417"
)
search.save!
puts "Created search for user: #{user.email} with clothing item: #{search.clothing_item}"


# brand seed
brand = Brand.new(
  name: "Patagonia",
  description: "Sustainable fashion brand focused on eco-friendly materials and ethical production.",
  planet_rating: 4.0,
  people_rating: 5.0,
  animals_rating: 4.0,
  overall_rating: 4.5,
)
brand.save!
puts "Created brand: #{brand.name}"

zara_brand = Brand.new(
  name: "Zara",
  description: "Global fast fashion retailer offering trendy clothing and accessories.",
  planet_rating: 2.0,
  people_rating: 3.0,
  animals_rating: 2.0,
  overall_rating: 2.5,
)
zara_brand.save!
puts "Created brand: #{zara_brand.name}"

# comparison products seed
comparison_product = ComparisonProduct.new(
  clothing_item: "T-shirt",
  clothing_material: "Recycled Cotton",
  clothing_colour: "Black",
  clothing_size: "M",
  clothing_brand: "EcoWear",
  clothing_price: 19.99,
  external_link: "https://www.patagonia.com/product/mens-p-6-logo-responsibili-tee/38504.html?dwvar_38504_color=BLK",
  product_description: "EcoWear's black T-shirt made from 100% recycled cotton, promoting sustainable fashion.",
  item_image: "https://www.patagonia.com/dw/image/v2/BDJB_PRD/on/demandware.static/-/Sites-patagonia-master/default/dwb6b434d7/images/hi-res/38504_BLK_JF1.jpg?sw=64&sh=64&sfrm=png&q=80&bgcolor=f3f4ef",
  brand: brand
)
comparison_product.save!
puts "Created comparison product: #{comparison_product.clothing_item} from brand: #{comparison_product.clothing_brand}"

# matches record seed
matches = Match.new(
  search: search,
  comparison_product: ComparisonProduct.first,
  similarities: "Both are black T-shirts made of polyamide material, suitable for casual wear"
)

matches.save!
puts "Created match for search id: #{search.id} with comparison product id: #{matches.comparison_product.id}"



# wishlist items seed
wishlist_item = WishlistItem.new(
  user: user,
  match: matches,
  comparison_product: comparison_product
)
wishlist_item.save!
puts "Created wishlist item for user: #{user.email} with comparison product id: #{wishlist_item.comparison_product.id}"
puts "Seeding completed."
