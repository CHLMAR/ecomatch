# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# =============================================================================
# User Seed
# =============================================================================
user = User.find_or_create_by!(email: "eco@match.com") do |u|
  u.password = "test123"
end
puts "User: #{user.email}"

# =============================================================================
# Brands
# =============================================================================

ecowear_brand = Brand.find_or_create_by!(name: "EcoWear") do |b|
  b.description = "Sustainable fashion brand focused on eco-friendly materials and ethical production."
  b.planet_rating = 4
  b.people_rating = 5
  b.animals_rating = 4
  b.overall_rating = 4
end
puts "Brand: #{ecowear_brand.name}"

zara_brand = Brand.find_or_create_by!(name: "Zara") do |b|
  b.description = "Global fast fashion retailer offering trendy clothing and accessories."
  b.planet_rating = 2
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{zara_brand.name}"

patagonia_brand = Brand.find_or_create_by!(name: "Patagonia") do |b|
  b.description = "Sustainable fashion brand focused on eco-friendly materials and ethical production."
  b.planet_rating = 4
  b.people_rating = 5
  b.animals_rating = 4
  b.overall_rating = 4
end
puts "Brand: #{patagonia_brand.name}"

levi_s_brand = Brand.find_or_create_by!(name: "Levi's") do |b|
  b.description = "Iconic denim brand"
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 3
  b.overall_rating = 3
end
puts "Brand: #{levi_s_brand.name}"

asket_brand = Brand.find_or_create_by!(name: "ASKET") do |b|
  b.description = "Swedish sustainable fashion brand focused on permanent essentials. Known for radical transparency, full supply chain traceability, and high-quality organic materials."
  b.planet_rating = 4
  b.people_rating = 4
  b.animals_rating = 4
  b.overall_rating = 4
end
puts "Brand: #{asket_brand.name}"

mud_jeans_brand = Brand.find_or_create_by!(name: "MUD Jeans") do |b|
  b.description = "Dutch circular denim brand pioneering lease-a-jeans model. Made from recycled and organic cotton, designed for recyclability."
  b.planet_rating = 5
  b.people_rating = 4
  b.animals_rating = 4
  b.overall_rating = 4
end
puts "Brand: #{mud_jeans_brand.name}"

lululemon_brand = Brand.find_or_create_by!(name: "Lululemon") do |b|
  b.description = "Athletic apparel company known for yoga wear and technical athletic clothing. Committed to sustainable practices including recycled materials and responsible manufacturing."
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 3
  b.overall_rating = 3
end
puts "Brand: #{lululemon_brand.name}"

etiko_brand = Brand.find_or_create_by!(name: "Etiko") do |b|
  b.description = "Australia's most ethical clothing brand. Fairtrade certified, 100% organic cotton, vegan-friendly. Committed to paying living wages and environmentally sustainable practices."
  b.planet_rating = 5
  b.people_rating = 5
  b.animals_rating = 5
  b.overall_rating = 5
end
puts "Brand: #{etiko_brand.name}"

kotn_brand = Brand.find_or_create_by!(name: "Kotn") do |b|
  b.description = "Certified B Corp (95.5 score) making essentials from Egyptian cotton. Direct trade with farmers in the Nile Delta, funding 15+ schools in rural Egypt. Transparent supply chain with SA 8000 and OEKO-TEX certified facilities."
  b.planet_rating = 3
  b.people_rating = 5
  b.animals_rating = 4
  b.overall_rating = 4
end
puts "Brand: #{kotn_brand.name}"

shein_brand = Brand.find_or_create_by!(name: "SHEIN") do |b|
  b.description = "Ultra fast fashion e-commerce platform known for extremely low prices and rapidly changing styles."
  b.planet_rating = 2
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{shein_brand.name}"

temu_brand = Brand.find_or_create_by!(name: "TEMU") do |b|
  b.description = "Ultra fast fashion marketplace with extremely low prices and aggressive marketing practices."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 2
  b.overall_rating = 1
end
puts "Brand: #{temu_brand.name}"

h_m_brand = Brand.find_or_create_by!(name: "H&M") do |b|
  b.description = "Swedish multinational fast fashion retailer known for affordable clothing."
  b.planet_rating = 3
  b.people_rating = 2
  b.animals_rating = 3
  b.overall_rating = 3
end
puts "Brand: #{h_m_brand.name}"

boohoo_brand = Brand.find_or_create_by!(name: "Boohoo") do |b|
  b.description = "UK-based online fast fashion retailer targeting young consumers."
  b.planet_rating = 1
  b.people_rating = 2
  b.animals_rating = 3
  b.overall_rating = 2
end
puts "Brand: #{boohoo_brand.name}"

fashion_nova_brand = Brand.find_or_create_by!(name: "Fashion Nova") do |b|
  b.description = "American fast fashion retailer known for trendy styles and social media marketing."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{fashion_nova_brand.name}"

forever_21_brand = Brand.find_or_create_by!(name: "Forever 21") do |b|
  b.description = "American fast fashion retailer targeting young consumers with trendy affordable clothing."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{forever_21_brand.name}"

uniqlo_brand = Brand.find_or_create_by!(name: "Uniqlo") do |b|
  b.description = "Japanese casual wear retailer known for basics and functional clothing."
  b.planet_rating = 3
  b.people_rating = 4
  b.animals_rating = 3
  b.overall_rating = 4
end
puts "Brand: #{uniqlo_brand.name}"

mango_brand = Brand.find_or_create_by!(name: "Mango") do |b|
  b.description = "Spanish clothing retailer offering Mediterranean-inspired fashion."
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 3
end
puts "Brand: #{mango_brand.name}"

asos_brand = Brand.find_or_create_by!(name: "ASOS") do |b|
  b.description = "British online fashion retailer selling multiple brands and own-label products."
  b.planet_rating = 2
  b.people_rating = 2
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{asos_brand.name}"

primark_brand = Brand.find_or_create_by!(name: "Primark") do |b|
  b.description = "Irish fast fashion retailer known for extremely low prices."
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 3
end
puts "Brand: #{primark_brand.name}"

topshop_brand = Brand.find_or_create_by!(name: "Topshop") do |b|
  b.description = "British fashion retailer known for trendy clothing targeting young consumers."
  b.planet_rating = 2
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{topshop_brand.name}"

missguided_brand = Brand.find_or_create_by!(name: "Missguided") do |b|
  b.description = "UK online fast fashion retailer targeting young women."
  b.planet_rating = 2
  b.people_rating = 1
  b.animals_rating = 4
  b.overall_rating = 2
end
puts "Brand: #{missguided_brand.name}"

nasty_gal_brand = Brand.find_or_create_by!(name: "Nasty Gal") do |b|
  b.description = "American fast fashion retailer known for edgy styles."
  b.planet_rating = 2
  b.people_rating = 2
  b.animals_rating = 3
  b.overall_rating = 2
end
puts "Brand: #{nasty_gal_brand.name}"

cider_brand = Brand.find_or_create_by!(name: "Cider") do |b|
  b.description = "Social-first fast fashion brand with crowdsourced designs."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 3
  b.overall_rating = 1
end
puts "Brand: #{cider_brand.name}"

zaful_brand = Brand.find_or_create_by!(name: "Zaful") do |b|
  b.description = "Chinese online fast fashion retailer known for cheap clothing."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{zaful_brand.name}"

romwe_brand = Brand.find_or_create_by!(name: "Romwe") do |b|
  b.description = "Chinese fast fashion e-commerce platform owned by SHEIN."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 2
  b.overall_rating = 1
end
puts "Brand: #{romwe_brand.name}"

urban_outfitters_brand = Brand.find_or_create_by!(name: "Urban Outfitters") do |b|
  b.description = "American lifestyle retail corporation selling clothing and home goods."
  b.planet_rating = 2
  b.people_rating = 2
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{urban_outfitters_brand.name}"

anthropologie_brand = Brand.find_or_create_by!(name: "Anthropologie") do |b|
  b.description = "American retailer selling clothing, accessories, and home decor with bohemian aesthetic."
  b.planet_rating = 2
  b.people_rating = 2
  b.animals_rating = 3
  b.overall_rating = 2
end
puts "Brand: #{anthropologie_brand.name}"

brandy_melville_brand = Brand.find_or_create_by!(name: "Brandy Melville") do |b|
  b.description = "Italian fast fashion brand known for one-size-fits-most clothing."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{brandy_melville_brand.name}"

princess_polly_brand = Brand.find_or_create_by!(name: "Princess Polly") do |b|
  b.description = "Australian online fashion retailer targeting young women."
  b.planet_rating = 2
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{princess_polly_brand.name}"

yesstyle_brand = Brand.find_or_create_by!(name: "YesStyle") do |b|
  b.description = "Hong Kong-based online retailer selling Asian fashion and beauty products."
  b.planet_rating = 1
  b.people_rating = 1
  b.animals_rating = 1
  b.overall_rating = 1
end
puts "Brand: #{yesstyle_brand.name}"

abercrombie_fitch_brand = Brand.find_or_create_by!(name: "Abercrombie & Fitch") do |b|
  b.description = "American lifestyle retailer known for casual luxury clothing."
  b.planet_rating = 2
  b.people_rating = 3
  b.animals_rating = 3
  b.overall_rating = 3
end
puts "Brand: #{abercrombie_fitch_brand.name}"

american_eagle_brand = Brand.find_or_create_by!(name: "American Eagle") do |b|
  b.description = "American clothing and accessories retailer targeting young adults."
  b.planet_rating = 3
  b.people_rating = 2
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{american_eagle_brand.name}"

victoria_s_secret_brand = Brand.find_or_create_by!(name: "Victoria's Secret") do |b|
  b.description = "American lingerie and beauty retailer."
  b.planet_rating = 2
  b.people_rating = 3
  b.animals_rating = 3
  b.overall_rating = 2
end
puts "Brand: #{victoria_s_secret_brand.name}"

gap_brand = Brand.find_or_create_by!(name: "GAP") do |b|
  b.description = "American worldwide clothing and accessories retailer."
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 3
  b.overall_rating = 3
end
puts "Brand: #{gap_brand.name}"

nike_brand = Brand.find_or_create_by!(name: "Nike") do |b|
  b.description = "American multinational corporation designing and selling athletic footwear and apparel."
  b.planet_rating = 3
  b.people_rating = 2
  b.animals_rating = 2
  b.overall_rating = 3
end
puts "Brand: #{nike_brand.name}"

adidas_brand = Brand.find_or_create_by!(name: "Adidas") do |b|
  b.description = "German multinational corporation designing and manufacturing athletic and casual footwear and apparel."
  b.planet_rating = 3
  b.people_rating = 2
  b.animals_rating = 2
  b.overall_rating = 2
end
puts "Brand: #{adidas_brand.name}"

bershka_brand = Brand.find_or_create_by!(name: "Bershka") do |b|
  b.description = "Spanish fast fashion retailer owned by Inditex, targeting young consumers."
  b.planet_rating = 3
  b.people_rating = 3
  b.animals_rating = 2
  b.overall_rating = 3
end
puts "Brand: #{bershka_brand.name}"

# =============================================================================
# Brand Logos (Cloudinary URLs)
# =============================================================================
brand_logos = {
  "Abercrombie & Fitch" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046636/development/brand_logos/abercrombie-fitch.png",
  "Adidas" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046246/development/brand_logos/adidas.png",
  "American Eagle" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046668/development/brand_logos/american-eagle.png",
  "Anthropologie" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046694/development/brand_logos/anthropologie.png",
  "ASKET" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047163/development/brand_logos/asket.png",
  "ASOS" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046530/development/brand_logos/asos.png",
  "Bershka" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046766/development/brand_logos/bershka.png",
  "Boohoo" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046808/development/brand_logos/boohoo.png",
  "Brandy Melville" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047187/development/brand_logos/brandy-melville.png",
  "Cider" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047208/development/brand_logos/cider.png",
  "Etiko" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047240/development/brand_logos/etiko.png",
  "Fashion Nova" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046850/development/brand_logos/fashion-nova.png",
  "Forever 21" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046716/development/brand_logos/forever-21.png",
  "GAP" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046251/development/brand_logos/gap.png",
  "H&M" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046253/development/brand_logos/h-m.png",
  "Kotn" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047274/development/brand_logos/kotn.png",
  "Levi's" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046364/development/brand_logos/levis.png",
  "Lululemon" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046391/development/brand_logos/lululemon.png",
  "Mango" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046410/development/brand_logos/mango.png",
  "Missguided" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047472/development/brand_logos/missguided.png",
  "MUD Jeans" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047297/development/brand_logos/mud-jeans.png",
  "Nasty Gal" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047136/development/brand_logos/nasty-gal.png",
  "Nike" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046255/development/brand_logos/nike.png",
  "Patagonia" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046347/development/brand_logos/patagonia.png",
  "Primark" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046827/development/brand_logos/primark.png",
  "Princess Polly" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047058/development/brand_logos/princess-polly.png",
  "Romwe" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047330/development/brand_logos/romwe.png",
  "SHEIN" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046434/development/brand_logos/shein.png",
  "TEMU" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046789/development/brand_logos/temu.png",
  "Topshop" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047487/development/brand_logos/topshop.png",
  "Uniqlo" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046256/development/brand_logos/uniqlo.png",
  "Urban Outfitters" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046613/development/brand_logos/urban-outfitters.png",
  "Victoria's Secret" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046745/development/brand_logos/victorias-secret.png",
  "YesStyle" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047356/development/brand_logos/yesstyle.png",
  "Zaful" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770047445/development/brand_logos/zaful.png",
  "Zara" => "https://res.cloudinary.com/dejcefe2o/image/upload/v1770046258/development/brand_logos/zara.png"
}

brand_logos.each do |name, logo_url|
  brand = Brand.find_by(name: name)
  if brand
    brand.update!(logo: logo_url)
    puts "  Logo set for #{name}"
  end
end
puts "Brand logos updated!"

# =============================================================================
# Comparison Products
# =============================================================================
# Delete dependent records first to avoid foreign key violations
WishlistItem.destroy_all
Match.destroy_all
ComparisonProduct.destroy_all
# Patagonia Products
patagonia_products = [
  {
    clothing_item: "Pants",
    clothing_material: "9.9-oz 99% Cotton in Conversion/1% spandex comfort-stretch 16-wale corduroy",
    clothing_colour: "Dried Vanilla",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-wide-leg-corduroy-pants/56910.html",
    product_description: "Women's Wide-Leg Corduroy Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707005/ecomatch/patagonia/women-s-wide-leg-corduroy-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "3.8-oz 65% recycled polyester/35% organic cotton twill",
    clothing_colour: "Otter Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-everyday-cord-straight-pants/22150.html",
    product_description: "Women's Everyday Cord Straight Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707013/ecomatch/patagonia/women-s-everyday-cord-straight-pants.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "600-fill-power 100% Recycled Down (a blend of duck and goose down and waterfowl feathers reclaimed from down products)",
    clothing_colour: "Deer Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-cord-fjord-flannel-lined-jacket/20335.html",
    product_description: "Women's Cord Fjord Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707029/ecomatch/patagonia/women-s-cord-fjord-jacket.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Talon Gold",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-p-6-logo-responsibili-tee/38504.html",
    product_description: "Men's P-6 Logo Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707037/ecomatch/patagonia/men-s-p-6-logo-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.4-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "White",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-long-sleeved-p-6-logo-responsibili-tee/37603.html",
    product_description: "Women's Long-Sleeved P-6 Logo Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707045/ecomatch/patagonia/women-s-long-sleeved-p-6-logo-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "White",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-strataspire-responsibili-tee/37839.html",
    product_description: "Men's Strataspire Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707061/ecomatch/patagonia/men-s-strataspire-responsibili-tee.jpg"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "4.7-oz 100% organic cotton jersey",
    clothing_colour: "Current Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-long-way-round-organic-shirt/37826.html",
    product_description: "Men's Long Way 'Round Organic Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707078/ecomatch/patagonia/men-s-long-way-round-organic-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Talon Gold",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-shop-sticker-pocket-responsibili-tee/37837.html",
    product_description: "Men's Shop Sticker Pocket Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707086/ecomatch/patagonia/men-s-shop-sticker-pocket-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Clement Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-boardshort-logo-pocket-responsibili-tee/37655.html",
    product_description: "Men's Boardshort Logo Pocket Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707095/ecomatch/patagonia/men-s-boardshort-logo-pocket-responsibili-tee.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "7.8-oz 97% organic cotton/3% spandex stretch canvas",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-classic-straight-canvas-pants-26-inch/22160.html",
    product_description: "Women's Classic Straight Pants - 26\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769706989/ecomatch/patagonia/women-s-classic-straight-pants-26.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "6.4-oz 100% Cotton in Conversion plain weave with a peached face",
    clothing_colour: "Dark Natural",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-corduroy-overshirt-jacket/20355.html",
    product_description: "Women's Corduroy Overshirt Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707021/ecomatch/patagonia/women-s-corduroy-overshirt-jacket.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4.6-oz 100% organic cotton jersey",
    clothing_colour: "Dried Vanilla",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-73-skyline-organic-cotton-t-shirt/37534.html",
    product_description: "Men's '73 Skyline Organic T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707070/ecomatch/patagonia/men-s-73-skyline-organic-t-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-unity-fitz-responsibili-tee/37768.html",
    product_description: "Men's Unity Fitz Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707103/ecomatch/patagonia/men-s-unity-fitz-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.8-oz 70% organic cotton/30% hemp jersey",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/foundation-work-t-shirt/53180.html",
    product_description: "Foundation Work T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707143/ecomatch/patagonia/foundation-work-t-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4-oz 100% organic cotton ringspun jersey",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/kids-long-sleeved-graphic-t-shirt/62274.html",
    product_description: "Kids' Long-Sleeved Graphic T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707151/ecomatch/patagonia/kids-long-sleeved-graphic-t-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4.4-oz 100% Regenerative Organic Certified® cotton jersey",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/baby-graphic-t-shirt/60389.html",
    product_description: "Baby Graphic T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707159/ecomatch/patagonia/baby-graphic-t-shirt.jpg"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "4.7-oz 100% organic cotton jersey",
    clothing_colour: "Ink Black",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-long-sleeved-long-way-round-organic-shirt/37821.html",
    product_description: "Men's Long-Sleeved Long Way 'Round Organic Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707175/ecomatch/patagonia/men-s-long-sleeved-long-way-round-organic-shirt.jpg"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "9.7-oz 53% industrial hemp/42% organic cotton/5% spandex rib knit",
    clothing_colour: "Beeswax Tan",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-long-sleeved-work-pocket-shirt/53335.html",
    product_description: "Women's Long-Sleeved Work Pocket Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707192/ecomatch/patagonia/women-s-long-sleeved-work-pocket-shirt.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "13.3-oz 98% Regenerative Organic Certified® cotton/2% spandex rib knit",
    clothing_colour: "Salt Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-daily-sweatpants/21475.html",
    product_description: "Men's Daily Sweatpants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707200/ecomatch/patagonia/men-s-daily-sweatpants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "4.4-oz 96% NetPlus® postconsumer recycled nylon made from recycled fishing nets to help reduce ocean plastic pollution/4% spandex plain weave; with a durable water repellent (DWR) finish made without intentionally added PFAS, and 40+ UPF sun protection",
    clothing_colour: "Classic Tan",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-quandary-hiking-pants-regular/55183.html",
    product_description: "Men's Quandary Pants - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707208/ecomatch/patagonia/men-s-quandary-pants-regular.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "8-oz 68% organic cotton/32% polyester twill with a wicking finish",
    clothing_colour: "Forge Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-twill-traveler-chino-pants-regular/22120.html",
    product_description: "Men's Twill Traveler Chino Pants - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707216/ecomatch/patagonia/men-s-twill-traveler-chino-pants-regular.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "8-oz 68% organic cotton/32% polyester twill with a wicking finish",
    clothing_colour: "Slab Khaki",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-twill-traveler-5-pocket-pants-regular/22136.html",
    product_description: "Men's Twill Traveler 5-Pocket Pants - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707224/ecomatch/patagonia/men-s-twill-traveler-5-pocket-pants-regular.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "6.3-oz 81% NetPlus® postconsumer recycled nylon made from recycled fishing nets to help reduce ocean plastic pollution/19% spandex knit with miDori™ bioSoft for added wicking and softness",
    clothing_colour: "Old Growth Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-happy-hike-studio-pants/21218.html",
    product_description: "Women's Happy Hike Studio Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707248/ecomatch/patagonia/women-s-happy-hike-studio-pants.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4.6-oz 100% organic cotton jersey",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-water-people-organic-cotton-pocket-t-shirt/37734.html",
    product_description: "Men's Water People Organic Pocket T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707127/ecomatch/patagonia/men-s-water-people-organic-pocket-t-shirt.jpg"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "4.6-oz 100% organic cotton jersey",
    clothing_colour: "Marlow Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-long-sleeved-73-skyline-easy-cut-organic-shirt/37833.html",
    product_description: "Women's Long-Sleeved '73 Skyline Easy-Cut Organic Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707167/ecomatch/patagonia/women-s-long-sleeved-73-skyline-easy-cut-organic-s.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "8-oz 68% organic cotton/32% polyester twill with a wicking finish",
    clothing_colour: "Forge Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-twill-traveler-chino-pants-short/22115.html",
    product_description: "Men's Twill Traveler Chino Pants - Short",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707240/ecomatch/patagonia/men-s-twill-traveler-chino-pants-short.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "5.5-oz 89% recycled polyester/11% spandex cross-dye jersey with a peached face, a wicking finish and HeiQ® Mint odor control",
    clothing_colour: "Smolder Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-2-loose-quick-dry-travel-pants/21495.html",
    product_description: "Men's 2-Loose Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707280/ecomatch/patagonia/men-s-2-loose-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "8-oz 68% organic cotton/32% polyester twill with a wicking finish",
    clothing_colour: "Slab Khaki",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-twill-traveler-5-pocket-pants-short/22131.html",
    product_description: "Men's Twill Traveler 5-Pocket Pants - Short",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707288/ecomatch/patagonia/men-s-twill-traveler-5-pocket-pants-short.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "3.8-oz 65% recycled polyester/35% organic cotton twill",
    clothing_colour: "Old Growth Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-wide-wale-corduroy-pants/21595.html",
    product_description: "Women's Wide-Wale Corduroy Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707304/ecomatch/patagonia/women-s-wide-wale-corduroy-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "60-g Thermogreen® 100% recycled polyester",
    clothing_colour: "Smolder Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-insulated-powder-town-ski-snowboard-pants-regular/31171.html",
    product_description: "Men's Insulated Powder Town Pants - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707321/ecomatch/patagonia/men-s-insulated-powder-town-pants-regular.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.3-oz 100% recycled polyester brushed tricot",
    clothing_colour: "New Navy",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-better-sweater-fleece-jacket/25528.html",
    product_description: "Men's Better Sweater® Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707329/ecomatch/patagonia/men-s-better-sweater-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "60-g PrimaLoft® Gold Insulation Eco 100% postconsumer recycled polyester with P.U.R.E.™ (Produced Using Reduced Emissions) technology",
    clothing_colour: "Clement Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-nano-puff-insulated-jacket/84213.html",
    product_description: "Men's Nano Puff® Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707337/ecomatch/patagonia/men-s-nano-puff-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3-layer, 3.5-oz 50-denier ECONYL® 100% recycled nylon ripstop face, a polycarbonate PU membrane with 13% biobased content, a tricot backer and a durable water repellent (DWR) finish",
    clothing_colour: "Old Growth Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-torrentshell-3-layer-rain-jacket/85241.html",
    product_description: "Men's Torrentshell 3L Rain Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707353/ecomatch/patagonia/men-s-torrentshell-3l-rain-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3.5-oz 100% recycled polyester brushed mesh",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-retro-pile-fleece-jacket/22801.html",
    product_description: "Men's Retro Pile Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707361/ecomatch/patagonia/men-s-retro-pile-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.3-oz 100% recycled polyester brushed tricot",
    clothing_colour: "Dried Vanilla",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-classic-retro-x-fleece-jacket/23057.html",
    product_description: "Men's Classic Retro-X® Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707369/ecomatch/patagonia/men-s-classic-retro-x-fleece-jacket.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "7.2-oz 58% organic cotton/38% recycled polyester/4% spandex brushed heather terry",
    clothing_colour: "Sunken Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-ahnya-sweatpants/21974.html",
    product_description: "Women's Ahnya Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707272/ecomatch/patagonia/women-s-ahnya-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "60-g Thermogreen® 100% recycled polyester",
    clothing_colour: "Orange Peel",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-insulated-powder-town-ski-snowboard-pants-regular/31186.html",
    product_description: "Women's Insulated Powder Town Pants - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707296/ecomatch/patagonia/women-s-insulated-powder-town-pants-regular.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.3-oz 100% recycled polyester brushed tricot",
    clothing_colour: "Permafrost Purple",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-better-sweater-fleece-jacket/25543.html",
    product_description: "Women's Better Sweater® Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707345/ecomatch/patagonia/women-s-better-sweater-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3-layer, 3.5-oz 50-denier ECONYL® 100% recycled nylon ripstop face, a polycarbonate PU membrane with 13% biobased content, a tricot backer and a durable water repellent (DWR) finish",
    clothing_colour: "Current Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-torrentshell-3-layer-rain-jacket/85246.html",
    product_description: "Women's Torrentshell 3L Rain Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707409/ecomatch/patagonia/women-s-torrentshell-3l-rain-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "60-g PrimaLoft® Gold Insulation Eco 100% postconsumer recycled polyester with P.U.R.E.™ (Produced Using Reduced Emissions) technology",
    clothing_colour: "Clement Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/kids-nano-puff-brick-quilt-insulated-jacket/68001.html",
    product_description: "Kids' Nano Puff® Brick Quilt Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707417/ecomatch/patagonia/kids-nano-puff-brick-quilt-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "4-ply, 4.9-oz NetPlus® 100% postconsumer recycled nylon faille made from recycled fishing nets to help reduce ocean plastic pollution",
    clothing_colour: "Talon Gold",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/baby-micro-d-snap-t-fleece-jacket/60155.html",
    product_description: "Baby Micro D® Snap-T® Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707425/ecomatch/patagonia/baby-micro-d-snap-t-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.3-oz 100% recycled polyester brushed tricot",
    clothing_colour: "Natural",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-classic-retro-x-fleece-jacket/23075.html",
    product_description: "Women's Classic Retro-X® Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707433/ecomatch/patagonia/women-s-classic-retro-x-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "1.2-oz 100% recycled nylon ripstop with a durable water repellent (DWR) finish made without intentionally added PFAS",
    clothing_colour: "Cascade Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-houdini-windbreaker-jacket/24147.html",
    product_description: "Women's Houdini® Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707441/ecomatch/patagonia/women-s-houdini-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "80-g Thermogreen® 100% recycled polyester",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-windshadow-waterproof-jacket/26490.html",
    product_description: "Men's Windshadow Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707449/ecomatch/patagonia/men-s-windshadow-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3.5-oz 100% recycled polyester brushed mesh",
    clothing_colour: "River Rock Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-retro-pile-fleece-jacket/22795.html",
    product_description: "Women's Retro Pile Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707473/ecomatch/patagonia/women-s-retro-pile-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3-oz 100% recycled polyester brushed tricot mesh",
    clothing_colour: "Permafrost Purple",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-classic-microdini-fleece-jacket/23165.html",
    product_description: "Women's Classic Microdini Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707481/ecomatch/patagonia/women-s-classic-microdini-fleece-jacket.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-baggies-longs-7-inch-shorts/58035.html",
    product_description: "Men's Baggies™ Longs - 7\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707489/ecomatch/patagonia/men-s-baggies-longs-7.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz 100% recycled polyester double knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-multi-trails-shorts-8-inch/57602.html",
    product_description: "Men's Multi Trails Shorts - 8\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707497/ecomatch/patagonia/men-s-multi-trails-shorts-8.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.7-oz 100% recycled polyester jacquard fleece with hollow-core yarns",
    clothing_colour: "Pelican",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-r1-air-fleece-midlayer-jacket/40275.html",
    product_description: "Men's R1® Air Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707401/ecomatch/patagonia/men-s-r1-air-fleece-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "3-layer, 5-oz 75-denier 100% recycled polyester GORE-TEX ePE Performance shell with a tricot backer and a durable water repellent (DWR) finish",
    clothing_colour: "Clement Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-triolet-alpine-jacket/83403.html",
    product_description: "Men's Triolet Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707465/ecomatch/patagonia/men-s-triolet-jacket.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-baggies-shorts-5-inch/57022.html",
    product_description: "Men's Baggies™ Shorts - 5\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707505/ecomatch/patagonia/men-s-baggies-shorts-5.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-barely-baggies-shorts-2-half-inch/57044.html",
    product_description: "Women's Barely Baggies™ Shorts - 2½\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707538/ecomatch/patagonia/women-s-barely-baggies-shorts-2.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "9.5-oz 100% Regenerative Organic Certified® cotton canvas",
    clothing_colour: "Forge Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-heritage-stand-up-canvas-shorts-7-inch/57230.html",
    product_description: "Men's Heritage Stand Up® Shorts - 7\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707546/ecomatch/patagonia/men-s-heritage-stand-up-shorts-7.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz recycled polyester tricot mesh",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-hydropeak-volley-shorts-16-inch/86436.html",
    product_description: "Men's Hydropeak Volley Shorts - 16\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707562/ecomatch/patagonia/men-s-hydropeak-volley-shorts-16.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz 100% recycled polyester double knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-multi-trails-shorts-5-half-inch/57631.html",
    product_description: "Women's Multi Trails Shorts - 5½\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707580/ecomatch/patagonia/women-s-multi-trails-shorts-5.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "4.4-oz 96% NetPlus® postconsumer recycled nylon made from recycled fishing nets to help reduce ocean plastic pollution/4% spandex plain weave; with a durable water repellent (DWR) finish made without intentionally added PFAS",
    clothing_colour: "Wing Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-quandary-hiking-shorts-5-inch/58092.html",
    product_description: "Women's Quandary Shorts - 5\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707588/ecomatch/patagonia/women-s-quandary-shorts-5.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "4.5-oz 76% organic cotton/24% industrial hemp plain weave with an anti-pilling finish",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-lightweight-all-wear-hemp-shorts-8-inch/57805.html",
    product_description: "Men's Lightweight All-Wear Hemp Shorts - 8\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707596/ecomatch/patagonia/men-s-lightweight-all-wear-hemp-shorts-8.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "4.8-oz 59% organic cotton/28% recycled polyester/13% spandex ripstop with four-way stretch",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-home-waters-volley-shorts-16-inch/86385.html",
    product_description: "Men's Home Waters Volley Shorts - 16\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707607/ecomatch/patagonia/men-s-home-waters-volley-shorts-16.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Smolder Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/kids-baggies-shorts-5-inch-lined/67036.html",
    product_description: "Kids' Baggies™ Shorts 5\" - Lined",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707615/ecomatch/patagonia/kids-baggies-shorts-5-lined.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "6.3-oz 81% NetPlus® postconsumer recycled nylon made from recycled fishing nets to help reduce ocean plastic pollution/19% spandex knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-maipo-active-shorts-8-inch/57505.html",
    product_description: "Women's Maipo Shorts - 8\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707639/ecomatch/patagonia/women-s-maipo-shorts-8.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz 100% recycled polyester double knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Wetland Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-strider-pro-running-shorts-5-inch/24634.html",
    product_description: "Men's Strider Pro Shorts - 5\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707530/ecomatch/patagonia/men-s-strider-pro-shorts-5.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz recycled polyester tricot mesh",
    clothing_colour: "Tidepool Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-hydropeak-hybrid-walk-shorts-18-inch/86476.html",
    product_description: "Men's Hydropeak Hybrid Walk Shorts - 18\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707554/ecomatch/patagonia/men-s-hydropeak-hybrid-walk-shorts-18.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "4.4-oz 96% NetPlus® postconsumer recycled nylon made from recycled fishing nets to help reduce ocean plastic pollution/4% spandex plain weave; with a durable water repellent (DWR) finish made without intentionally added PFAS",
    clothing_colour: "Otter Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-quandary-hiking-shorts-10-inch/57828.html",
    product_description: "Men's Quandary Shorts - 10\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707631/ecomatch/patagonia/men-s-quandary-shorts-10.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "5.4-oz 65% Cotton in Conversion/35% recycled polyester twill",
    clothing_colour: "Ink Black",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-point-reyes-cotton-canvas-wide-leg-pants/22170.html",
    product_description: "Women's Point Reyes Canvas Wide-Leg Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769706997/ecomatch/patagonia/women-s-point-reyes-canvas-wide-leg-pants.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Cascade Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-long-sleeved-p-6-logo-responsibili-tee/38518.html",
    product_description: "Men's Long-Sleeved P-6 Logo Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707053/ecomatch/patagonia/men-s-long-sleeved-p-6-logo-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey",
    clothing_colour: "Clement Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-chouinard-crest-pocket-responsibili-tee/37770.html",
    product_description: "Men's Chouinard® Crest Pocket Responsibili-Tee®",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707111/ecomatch/patagonia/men-s-chouinard-crest-pocket-responsibili-tee.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4.4-oz 100% Regenerative Organic Certified® cotton jersey",
    clothing_colour: "Unknown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/kids-graphic-t-shirt/62146.html",
    product_description: "Kids' Graphic T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707119/ecomatch/patagonia/kids-graphic-t-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "9.7-oz 53% industrial hemp/42% organic cotton/5% spandex rib knit",
    clothing_colour: "Pumice",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-long-sleeved-work-pocket-t-shirt/53385.html",
    product_description: "Men's Long-Sleeved Work Pocket T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707135/ecomatch/patagonia/men-s-long-sleeved-work-pocket-t-shirt.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "4.6-oz 100% organic cotton jersey",
    clothing_colour: "Old Growth Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-73-text-logo-organic-cotton-t-shirt/37776.html",
    product_description: "Men's '73 Text Logo Organic T-Shirt",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707184/ecomatch/patagonia/men-s-73-text-logo-organic-t-shirt.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "7.8-oz 68% organic cotton/30% TENCEL™ lyocell/2% spandex comfort-stretch twill with a peached face",
    clothing_colour: "Deer Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-utility-pants/21925.html",
    product_description: "Women's Utility Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707232/ecomatch/patagonia/women-s-utility-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "8-oz 68% organic cotton/32% polyester twill with a wicking finish",
    clothing_colour: "Forge Grey",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-twill-traveler-chino-pants-long/22125.html",
    product_description: "Men's Twill Traveler Chino Pants - Long",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707256/ecomatch/patagonia/men-s-twill-traveler-chino-pants-long.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "5.4-oz 65% Cotton in Conversion/35% recycled polyester twill",
    clothing_colour: "Ink Black",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-point-reyes-cotton-canvas-gi-pants/22145.html",
    product_description: "Men's Point Reyes Canvas Gi Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707264/ecomatch/patagonia/men-s-point-reyes-canvas-gi-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "4-ply, 4.9-oz NetPlus® 100% postconsumer recycled nylon faille made from recycled fishing nets to help reduce ocean plastic pollution; with a durable water repellent (DWR) finish made without intentionally added PFAS",
    clothing_colour: "Black Solid",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-synchilla-fleece-pants/21665.html",
    product_description: "Men's Synchilla® Fleece Pants",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707312/ecomatch/patagonia/men-s-synchilla-fleece-pants.jpg"
  },
  {
    clothing_item: "Pants",
    clothing_material: "5.4-oz 65% Cotton in Conversion/35% recycled polyester twill",
    clothing_colour: "Otter Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-organic-cotton-corduroy-jeans-regular/21525.html",
    product_description: "Men's Organic Cotton Corduroy Jeans - Regular",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769706981/ecomatch/patagonia/men-s-organic-cotton-corduroy-jeans-regular.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "60-g Thermogreen® 100% recycled polyester with a polypropylene scrim for insulation stability and wash durability",
    clothing_colour: "Sunken Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-light-gust-insulated-jacket/20561.html",
    product_description: "Women's Light Gust Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707377/ecomatch/patagonia/women-s-light-gust-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "60-g PrimaLoft® Gold Insulation Eco 100% postconsumer recycled polyester with P.U.R.E.™ (Produced Using Reduced Emissions) technology",
    clothing_colour: "Dark Ruby",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-nano-puff-insulated-jacket/84218.html",
    product_description: "Women's Nano Puff® Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707384/ecomatch/patagonia/women-s-nano-puff-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "1.2-oz 100% recycled nylon ripstop with a durable water repellent (DWR) finish made without intentionally added PFAS",
    clothing_colour: "Pond Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-houdini-windbreaker-jacket/24142.html",
    product_description: "Men's Houdini® Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707392/ecomatch/patagonia/men-s-houdini-jacket.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "5.7-oz 100% recycled polyester jacquard fleece with hollow-core yarns",
    clothing_colour: "Wool White",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-r1-air-fleece-midlayer-jacket/40280.html",
    product_description: "Women's R1® Air Fleece Jacket",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707457/ecomatch/patagonia/women-s-r1-air-fleece-jacket.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Sequoia Red",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-baggies-shorts-5-inch/57059.html",
    product_description: "Women's Baggies™ Shorts - 5\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707513/ecomatch/patagonia/women-s-baggies-shorts-5.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz 100% recycled polyester double knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Marlow Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-multi-trails-shorts-6-inch/57595.html",
    product_description: "Men's Multi Trails Shorts - 6\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707522/ecomatch/patagonia/men-s-multi-trails-shorts-6.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "4.8-oz 59% organic cotton/28% recycled polyester/13% spandex ripstop with four-way stretch",
    clothing_colour: "Basin Green",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/mens-home-waters-hybrid-shorts-18-inch/86380.html",
    product_description: "Men's Home Waters Hybrid Shorts - 18\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707571/ecomatch/patagonia/men-s-home-waters-hybrid-shorts-18.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.3-oz 100% recycled polyester double knit with miDori™ bioSoft for added wicking and softness, and HeiQ® Mint odor control",
    clothing_colour: "Marlow Brown",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/womens-strider-pro-running-shorts-3-half-inch/24658.html",
    product_description: "Women's Strider Pro Shorts - 3½\"",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707623/ecomatch/patagonia/women-s-strider-pro-shorts-3.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "2.1-oz 100% recycled polyester tricot mesh",
    clothing_colour: "Smolder Blue",
    clothing_brand: "Patagonia",
    clothing_price: 99.0,
    external_link: "https://www.patagonia.com/product/kids-baggies-shorts-7-inch-lined/67053.html",
    product_description: "Kids' Baggies™ Shorts 7\" - Lined",
    item_image: "https://res.cloudinary.com/dejcefe2o/image/upload/v1769707648/ecomatch/patagonia/kids-baggies-shorts-7-lined.jpg"
  }
]

patagonia_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = patagonia_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{patagonia_products.length} Patagonia products"

# Levi's Products
levi_s_products = [
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Light Workout",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/468-loose-fit-mens-shorts/p/A84610039",
    product_description: "468 Loose Fit Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_A8461-0039_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Max Volume",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/baggy-barrel-mens-jeans/p/0057O0001",
    product_description: "Baggy Barrel Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_0057O-0001_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=155&hei=155"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Hold My Bag",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/loose/extra-baggy-mens-jeans/p/006IC0000",
    product_description: "Extra Baggy Men's Jeans",
    item_image: "https://lsco.scene7.com/is/image/lsco/006IC0000-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=155&hei=155"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Filbert Nights",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/jeans-by-fit-number/men/jeans/501/501-original-fit-mens-jeans/p/005013793",
    product_description: "501® Original Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00501-3793_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=155&hei=155"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Olive Night",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/jeans-by-fit-number/men/jeans/505/505TM-regular-fit-mens-jeans/p/005053161",
    product_description: "505™ Regular Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00505-3161_GLO_CM_FV?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=155&hei=155"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "Denim",
    clothing_colour: "Clean Run",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/514TM-straight-fit-mens-jeans/p/005141592",
    product_description: "514™ Straight Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00514-1592_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=155&hei=155"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Grey Nights",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/loose/578TM-baggy-mens-jeans/p/A47500058",
    product_description: "578™ Baggy Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_A4750-0058_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "70% Cotton, 28% Lyocell (Lenzing TENCEL™ Lyocell), 2% LYCRA®",
    clothing_colour: "Play A Tune",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/taper/541TM-athletic-taper-fit-mens-jeans/p/181810950",
    product_description: "541™ Athletic Taper Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_18181-0950_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "River Bank Cool",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/slim/511TM-slim-fit-mens-jeans/p/045116321",
    product_description: "511™ Slim Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_04511-6321_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Denim De Jour",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/559TM-relaxed-straight-fit-mens-jeans/p/005590649",
    product_description: "559™ Relaxed Straight Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00559-0649_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "Always The Optimist",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/bootcut/517TM-bootcut-mens-jeans/p/005170291",
    product_description: "517™ Bootcut Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00517-0291_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "70% Cotton, 28% Lyocell (Lenzing TENCEL™ Lyocell), 2% LYCRA®",
    clothing_colour: "Shrouded In Mystery",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/slim/512TM-slim-taper-fit-mens-jeans/p/288331513",
    product_description: "512™ Slim Taper Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_28833-1513_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Thats The Answer",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/loose/565TM-loose-straight-mens-jeans/p/A72210068",
    product_description: "565™ Loose Straight Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_A7221-0068_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Until Its Dust",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/loose/568TM-loose-straight-mens-jeans/p/290370147",
    product_description: "568™ Loose Straight Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_29037-0147_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Lake Side Cool",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/taper/502TM-taper-fit-performance-cool-mens-jeans/p/295071775",
    product_description: "502™ Taper Fit Performance Cool Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_29507-1775_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "Denim",
    clothing_colour: "New Selvedge Rinse",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/jeans-by-fit-number/men/jeans/501/501-original-fit-selvedge-mens-jeans/p/005013683",
    product_description: "501® Original Fit Selvedge Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00501-3683_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Style Tension Distressed",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/relaxed/555TM-relaxed-straight-mens-jeans/p/000LO0054",
    product_description: "555™ Relaxed Straight Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_000LO-0054_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Night Shadows",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/taper/502TM-taper-fit-mens-jeans/p/295071804",
    product_description: "502™ Taper Fit Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_29507-1804_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "All I Can Do",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/straight/514TM-straight-fit-lightweight-mens-jeans/p/005142018",
    product_description: "514™ Straight Fit Lightweight Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00514-2018_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Wherever You Are",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/jeans/loose/extra-baggy-mens-jeans/p/006IC0003",
    product_description: "Extra Baggy Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_006IC-0003_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Greatest Story Selvedge",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/jeans-by-fit-number/men/jeans/505/505TM-regular-fit-selvedge-mens-jeans/p/005053277",
    product_description: "505™ Regular Fit Selvedge Men's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_00505-3277_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "95% Cotton, 5% Recycled Cotton",
    clothing_colour: "Rebel Edge",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/easy-dad-womens-jeans/p/005DC0002",
    product_description: "Easy Dad Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_005DC-0002_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Easy Days",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/loose/loose-boot-womens-jeans/p/005DO0000",
    product_description: "Loose Boot Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_005DO-0000_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "55% Cotton, 45% Lyocell (Lenzing TENCEL™ Lyocell)",
    clothing_colour: "Lost In Translation",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/loose/low-loose-womens-jeans/p/A55660064",
    product_description: "Low Loose Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A5566-0064_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Office Refresh",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/501-90s-womens-jeans/p/A19590115",
    product_description: "501® '90s Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A1959-0115_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Chipped Winter Twig",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/wide-leg/ribcage-wide-leg-womens-jeans/p/A60810075",
    product_description: "Ribcage Wide Leg Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A6081-0075_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Chipped Winter Twig",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/501-original-fit-womens-jeans/p/125010638",
    product_description: "501® Original Fit Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_12501-0638_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% Cotton, 19% Polyester, 1% LYCRA®",
    clothing_colour: "Up And Away",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/314-shaping-straight-womens-jeans/p/196310302",
    product_description: "314 Shaping Straight Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_19631-0302_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "9% Lyocell (Lenzing TENCEL™ Lyocell), 88% Cotton, 2% Elastomultiester (T400), 1% LYCRA®",
    clothing_colour: "Analyze This Ltw",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/ribcage-straight-ankle-womens-jeans/p/726930281",
    product_description: "Ribcage Straight Ankle Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_72693-0281_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "My Honor No Dx",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/ribcage-full-length-womens-jeans/p/790780064",
    product_description: "Ribcage Full Length Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_79078-0064_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "Dance Around",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/wedgie-straight-ankle-womens-jeans/p/349640278",
    product_description: "Wedgie Straight Ankle Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_34964-0278_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "Bite Back Wb",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/bootcut/wedgie-bootcut-womens-jeans/p/A87100020",
    product_description: "Wedgie Bootcut Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A8710-0020_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "84% Cotton, 15% Polyester, 1% LYCRA®",
    clothing_colour: "Darted Denim",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/bootcut/superlow-bootcut-womens-jeans/p/A46790043",
    product_description: "Superlow Bootcut Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A4679-0043_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "81% Cotton, 18% Polyester, 1% LYCRA®",
    clothing_colour: "Beneath The Shadows",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/724-high-rise-straight-womens-jeans/p/188830458",
    product_description: "724 High Rise Straight Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_18883-0458_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Lift Up",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/cinch-barrel-womens-jeans/p/003V50009",
    product_description: "Cinch Barrel Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_003V5-0009_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "Off Roading Stf Str",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/501-curve-womens-jeans/p/0036A0046",
    product_description: "501® Curve Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_0036A-0046_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% Cotton, 19% Polyester, 1% LYCRA®",
    clothing_colour: "Where We Going",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/skinny/311-shaping-skinny-womens-jeans/p/196260653",
    product_description: "311 Shaping Skinny Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_19626-0653_LSE_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Natural Style",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/straight/501-90s-ankle-womens-jeans/p/A91500018",
    product_description: "501® '90s Ankle Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A9150-0018_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% LYCRA®",
    clothing_colour: "On The Town",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/women/jeans/bootcut/ribcage-bell-womens-jeans/p/A75030007",
    product_description: "Ribcage Bell Women's Jeans",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/WB_A7503-0007_GLO_CM_FV?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Lombard Nights",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/trucker-jacket/p/723340795",
    product_description: "Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_72334-0795_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "At Midnight",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/relaxed-fit-trucker-jacket/p/A57820103",
    product_description: "Relaxed Fit Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A5782-0103_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Made with 100% cotton",
    clothing_colour: "Twist And Sew",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/market-miners-trucker-jacket/p/005AD0002",
    product_description: "Market Miners Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AD-0002_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Made with 100% cotton",
    clothing_colour: "Dark Phantom",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/market-miners-corduroy-trucker-jacket/p/005AD0001",
    product_description: "Market Miners Corduroy Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AD-0001_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Marris Stripe",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/potrero-hooded-jacket/p/A32220019",
    product_description: "Potrero Hooded Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A3222-0019_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Dried Oregano Chore",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/berkley-canvas-chore-coat/p/003B00004",
    product_description: "Berkley Canvas Chore Coat",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_003B0-0004_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Sunburnt Chore",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/berkley-chore-coat/p/003B00003",
    product_description: "Berkley Chore Coat",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_003B0-0003_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "My Tinted Journey",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/cortland-denim-jacket/p/005AM0003",
    product_description: "Cortland Denim Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AM-0003_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Vintage Khaki",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/cortland-canvas-jacket/p/005AM0002",
    product_description: "Cortland Canvas Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AM-0002_LSE_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Denim",
    clothing_colour: "Unknown",
    clothing_brand: "Levi's",
    clothing_price: 0.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/relaxed-fit-trucker-jacket/p/A57820104",
    product_description: "Relaxed Fit Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A5782-0104_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Built To Last Sherpa",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/type-iii-sherpa-trucker-jacket/p/163650291",
    product_description: "Type Iii Sherpa Trucker Jacket",
    item_image: "https://lsco.scene7.com/is/image/lsco/163650291-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Denim",
    clothing_colour: "Jet Black",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/ma-1-bomber-jacket/p/005AL0000",
    product_description: "Ma-1 Bomber Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AL-0000_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Dark Indigo Flat",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/embarcadero-station-trucker-jacket/p/0010P0011",
    product_description: "Embarcadero Station Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_0010P-0011_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Meteorite",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/sansome-vest/p/A85800005",
    product_description: "Sansome Vest",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A8580-0005_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Tiger's Eye",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/castro-mechanics-full-zip-canvas-jacket/p/005AF0004",
    product_description: "Castro Mechanics Full-zip Canvas Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AF-0004_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Berk Night",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/trucker-jacket/p/723340797",
    product_description: "Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_72334-0797_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Cloudy Days",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/jaanai-jacket/p/005AK0000",
    product_description: "Jaanai Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_005AK-0000_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Wash It Out Rinse",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/outerwear/relaxed-fit-trucker-jacket/p/A57820083",
    product_description: "Relaxed Fit Trucker Jacket",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A5782-0083_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Grunge Wash Smoked Pearl",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-grunge-wash-t-shirt/p/A06370179",
    product_description: "Authentic Red Tab™ Vintage Grunge Wash T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0179_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Rheem Overdye Stripe Pumice Stone",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-overdye-t-shirt/p/A06370190",
    product_description: "Authentic Red Tab™ Vintage Overdye T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0190_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Greenwich Denim",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/classic-western-standard-fit-shirt/p/857450234",
    product_description: "Classic Western Standard Fit Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_85745-0234_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Atila Plaid Dress Blues",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-button-down-shirt/p/A72100058",
    product_description: "Authentic Button-down Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A7210-0058_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Garment Dye Pumice Stone",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-button-down-garment-dye-shirt/p/A72100060",
    product_description: "Authentic Button-down Garment Dye Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A7210-0060_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Garment Dye Oxblood Red",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/long-sleeve-relaxed-thermal-garment-dye-shirt/p/A92490027",
    product_description: "Long-sleeve Relaxed Thermal Garment Dye Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A9249-0027_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Blackened Pearl",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/housemark-polo-shirt/p/358830352",
    product_description: "Housemark Polo Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_35883-0352_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Solucell Western",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/barstow-western-denim-shirt/p/857440117",
    product_description: "Barstow Western Denim Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_85744-0117_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Garment Dye Zodiac Blue",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/boxy-short-sleeve-garment-dye-t-shirt/p/0049F0027",
    product_description: "Boxy Short-sleeve Garment Dye T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_0049F-0027_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Falke Birch Camo Silvery Tonal",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/boxy-short-sleeve-grunge-wash-t-shirt/p/0049F0015",
    product_description: "Boxy Short-sleeve Grunge Wash T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_0049F-0015_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Bandana Maitake",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/classic-graphic-t-shirt/p/224912112",
    product_description: "Classic Graphic T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_22491-2112_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Grunge Wash Roan Rouge",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-grunge-wash-t-shirt/p/A06370178",
    product_description: "Authentic Red Tab™ Vintage Grunge Wash T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0178_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Rheem Overdye Stripe Smoked Pearl",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-overdye-t-shirt/p/A06370191",
    product_description: "Authentic Red Tab™ Vintage Overdye T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0191_GLO_CL_FV?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Mineral Black",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-t-shirt/p/A06370001",
    product_description: "Authentic Red Tab™ Vintage T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0001_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Garment Dye Khaki Green",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/authentic-red-tabTM-vintage-garment-dye-t-shirt/p/A06370175",
    product_description: "Authentic Red Tab™ Vintage Garment Dye T-shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A0637-0175_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Aldo Plaid Allure Twill",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/classic-western-standard-fit-shirt/p/857450277",
    product_description: "Classic Western Standard Fit Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_85745-0277_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Oxblood Chambray",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/auburn-long-sleeve-worker-shirt/p/A72240024",
    product_description: "Auburn Long-sleeve Worker Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A7224-0024_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% Cotton",
    clothing_colour: "Garment Dye Kevin Russet Brown",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shirts/auburn-long-sleeve-worker-garment-dye-shirt/p/A72240017",
    product_description: "Auburn Long-sleeve Worker Garment Dye Shirt",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MT_A7224-0017_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Early Nights",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/501-original-fit-mens-shorts/p/365120279",
    product_description: "501® Original Fit Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_36512-0279_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Ombre Camo Soft Camo",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/carrier-cargo-mens-shorts/p/001KG0055",
    product_description: "Carrier Cargo Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_001KG-0055_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "99% Cotton, 1% Elastane",
    clothing_colour: "Indigo Commercials",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/405-standard-fit-10-mens-shorts/p/398640210",
    product_description: "405 Standard Fit 10\" Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_39864-0210_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Pants",
    clothing_material: "100% Cotton",
    clothing_colour: "Harvest Gold",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/xx-chino-authentic-relaxed-fit-lightweight-twill-mens-shorts/p/A46610058",
    product_description: "Xx Chino Authentic Relaxed Fit Lightweight Twill Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_A4661-0058_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Next One Down",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/454-relaxed-fit-10-mens-shorts/p/000YB0020",
    product_description: "454 Relaxed Fit 10\" Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_000YB-0020_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Ombre Camo Soft Camo",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/big-tall/carrier-cargo-mens-shorts-big-tall/p/001KH0008",
    product_description: "Carrier Cargo Men's Shorts (big & Tall)",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_001KH-0008_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Light Score",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/469-loose-12-mens-shorts/p/394340015",
    product_description: "469 Loose 12\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/394340015-front-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Pants",
    clothing_material: "64% Cotton, 6% Elastomultiester, 28% Linen, 2% Elastane",
    clothing_colour: "Kambaba",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/xx-chino-lightweight-linen-blend-mens-shorts/p/172020091",
    product_description: "Xx Chino Lightweight Linen Blend Men's Shorts",
    item_image: "https://lscoglobal.scene7.com/is/image/lscoglobal/MB_17202-0091_GLO_CM_DA?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "Medium Score",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/405-standard-10-mens-shorts/p/398640004",
    product_description: "405 Standard 10\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/398640004-front-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% Cotton",
    clothing_colour: "My Pockets Full",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/478TM-baggy-12-mens-shorts/p/001JM0006",
    product_description: "478™ Baggy 12\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/001JM0006-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "70% Cotton, 28% Lyocell (Lenzing TENCEL™ Lyocell), 2% LYCRA®",
    clothing_colour: "Automatic Rizz",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/412-slim-fit-9-mens-shorts/p/393870102",
    product_description: "412 Slim Fit 9\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/393870102-front-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Pants",
    clothing_material: "98% Cotton, 2% Elastane",
    clothing_colour: "British Khaki X",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/xx-chino-relaxed-mens-shorts/p/001KF0008",
    product_description: "Xx Chino Relaxed Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/001KF0008-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "3Pm In Soma",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/501-original-fit-lightweight-9-mens-shorts/p/365120269",
    product_description: "501® Original Fit Lightweight 9\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/365120269-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "95% Cotton, 3% Elastomultiester, 2% Elastane",
    clothing_colour: "Icarus Sun Short",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/445-athletic-10-mens-shorts/p/A72190001",
    product_description: "445 Athletic 10\" Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/A72190001-front-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "82% Cotton, 18% Linen",
    clothing_colour: "Rewrite Hope",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/468-stay-loose-9-linen-denim-mens-shorts/p/A84610012",
    product_description: "468 Stay Loose 9\" Linen+ Denim Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/A84610012-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Pants",
    clothing_material: "98% Cotton, 2% Spandex",
    clothing_colour: "True Chino",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/xx-chino-taper-fit-mens-shorts/p/172020008",
    product_description: "Xx Chino Taper Fit Men's Shorts",
    item_image: "https://lsco.scene7.com/is/image/lsco/172020008-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Mello Mornings",
    clothing_brand: "Levi's",
    clothing_price: 75.0,
    external_link: "https://www.levi.com/US/en_US/clothing/men/shorts/478TM-baggy-mens-capris/p/004A80001",
    product_description: "478™ Baggy Men's Capris",
    item_image: "https://lsco.scene7.com/is/image/lsco/004A80001-dynamic1-pdp?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=800&hei=1066"
  }
]

levi_s_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = levi_s_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{levi_s_products.length} Levi's products"

# ASKET Products
asket_products = [
  {
    clothing_item: "Jeans",
    clothing_material: "98% organic cotton 2% recycled elastane",
    clothing_colour: "Grey Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-slim-jeans-grey-wash",
    product_description: "The Slim Jeans",
    item_image: "https://images.asket.com/pim-images/1755173696-asket_bd2-mk-gyw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Mid Blue Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-regular-jeans-mid-blue-wash",
    product_description: "The Regular Jeans",
    item_image: "https://images.asket.com/pim-images/1755182340-asket_wd3-mk-mbw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Raw Denim",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-regular-jeans-raw-denim",
    product_description: "The Regular Jeans",
    item_image: "https://images.asket.com/pim-images/1755177598-asket_rd3-mk-rwd_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "98,5% organic cotton 1,5% degradable elastane",
    clothing_colour: "Mid Blue Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-slim-jeans-mid-blue-wash",
    product_description: "The Slim Jeans",
    item_image: "https://images.asket.com/pim-images/1755179999-asket_wd2-mk-mbw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Light Blue Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-regular-jeans-light-blue-wash",
    product_description: "The Regular Jeans",
    item_image: "https://images.asket.com/pim-images/1755181048-asket_wd3-mk-lbw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Grey Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-regular-jeans-grey-wash",
    product_description: "The Regular Jeans",
    item_image: "https://images.asket.com/pim-images/1755173625-asket_bd3-mk-gyw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-regular-jeans-black",
    product_description: "The Regular Jeans",
    item_image: "https://images.asket.com/pim-images/1755173603-asket_bd3-mk-bla_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Raw Denim",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-slim-jeans-raw-denim",
    product_description: "The Slim Jeans",
    item_image: "https://images.asket.com/pim-images/1755177827-asket_rd2-mk-rwd_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Light Blue Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-loose-jeans-light-blue-wash",
    product_description: "The Loose Jeans",
    item_image: "https://images.asket.com/pim-images/1755182405-asket_wd4-mk-lbw_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "98% organic cotton 2% recycled elastane",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-slim-jeans-black",
    product_description: "The Slim Jeans",
    item_image: "https://images.asket.com/pim-images/1755172781-asket_bd2-mk-bla_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-loose-jeans-black",
    product_description: "The Loose Jeans",
    item_image: "https://images.asket.com/pim-images/1755173854-asket_bd4-mk-bla_slideshow_1.jpg"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton",
    clothing_colour: "Grey Wash",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-loose-jeans-grey-wash",
    product_description: "The Loose Jeans",
    item_image: "https://images.asket.com/pim-images/1755173823-asket_bd4-mk-gyw_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "White",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-white",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755179769-asket_tee-ma-whi_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-black",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755179606-asket_tee-ma-bla_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-dark-navy",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755179056-asket_tee-ma-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Dusty Green",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-dusty-green",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755179220-asket_tee-ma-dyg_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Charcoal Melange",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-charcoal-melange",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755179747-asket_tee-ma-clm_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Off White",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-off-white",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755182305-asket_tee-ma-ofw_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Grey Melange",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-grey-melange",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755180293-asket_tee-ma-gym_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "White",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/womens-t-shirt-white",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755181577-asket_yte-wh-whi_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/womens-t-shirt-black",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755181303-asket_yte-wh-bla_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Burgundy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-t-shirt-burgundy",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755178927-asket_tee-ma-bur_slideshow_1.jpg"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Grey Melange",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/womens-t-shirt-grey-melange",
    product_description: "The T-Shirt",
    item_image: "https://images.asket.com/pim-images/1755181711-asket_yte-wh-gym_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% recycled wool",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-wool-coat-dark-navy",
    product_description: "The Wool Coat",
    item_image: "https://images.asket.com/pim-images/1755182289-asket_wct-ma-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% recycled wool",
    clothing_colour: "Charcoal Melange",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-wool-coat-charcoal-melange",
    product_description: "The Wool Coat",
    item_image: "https://images.asket.com/pim-images/1755180468-asket_wct-ma-clm_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% organic cotton",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-car-coat-dark-navy",
    product_description: "The Car Coat",
    item_image: "https://images.asket.com/pim-images/1755173963-asket_cct-ma-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% organic cotton",
    clothing_colour: "Beige",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-car-coat-beige",
    product_description: "The Car Coat",
    item_image: "https://images.asket.com/pim-images/1755173056-asket_cct-ma-bei_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% organic cotton",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-field-jacket-dark-navy",
    product_description: "The Field Jacket",
    item_image: "https://images.asket.com/pim-images/1755175068-asket_fjt-ma-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% organic cotton",
    clothing_colour: "Khaki Green",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-field-jacket-khaki-green",
    product_description: "The Field Jacket",
    item_image: "https://images.asket.com/pim-images/1755175084-asket_fjt-ma-kig_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% recycled nylon",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-zip-jacket-dark-navy",
    product_description: "The Zip Jacket",
    item_image: "https://images.asket.com/pim-images/1755181785-asket_zjt-ma-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% organic cotton",
    clothing_colour: "Stone Bleach",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-washed-denim-jacket-stone-bleach",
    product_description: "The Washed Denim Jacket",
    item_image: "https://images.asket.com/pim-images/1755180562-asket_wjt-ma-seb_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% organic cotton",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-shorts-dark-navy",
    product_description: "The Shorts",
    item_image: "https://images.asket.com/pim-images/1769180015-asket_sh3-mn-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% organic cotton",
    clothing_colour: "Beige",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-shorts-beige",
    product_description: "The Shorts",
    item_image: "https://images.asket.com/pim-images/1755182241-asket_sh3-mn-bei_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% organic cotton",
    clothing_colour: "Olive",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-shorts-olive",
    product_description: "The Shorts",
    item_image: "https://images.asket.com/pim-images/1755177748-asket_sh3-mn-oli_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% linen",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-linen-shorts-dark-navy",
    product_description: "The Linen Shorts",
    item_image: "https://images.asket.com/pim-images/1755175686-asket_ls3-mn-dkn_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% linen",
    clothing_colour: "Sand",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-linen-shorts-sand",
    product_description: "The Linen Shorts",
    item_image: "https://images.asket.com/pim-images/1769180494-asket_ls3-mn-bei_slideshow_1.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% recycled polyester",
    clothing_colour: "Cold Blue",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-swim-shorts-cold-blue",
    product_description: "The Swim Shorts",
    item_image: "https://images.asket.com/pim-images/1755179590-asket_sws-mc-cdb_thumbnail.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% recycled polyester",
    clothing_colour: "Black",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-swim-shorts-black",
    product_description: "The Swim Shorts",
    item_image: "https://images.asket.com/pim-images/1755179154-asket_sws-mc-bla_thumbnail.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% recycled polyester",
    clothing_colour: "Dark Navy",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-swim-shorts-dark-navy",
    product_description: "The Swim Shorts",
    item_image: "https://images.asket.com/pim-images/1755179495-asket_sws-mc-dkn_thumbnail.jpg"
  },
  {
    clothing_item: "Shorts",
    clothing_material: "100% recycled polyester",
    clothing_colour: "Cold Green",
    clothing_brand: "ASKET",
    clothing_price: 80.0,
    external_link: "https://www.asket.com/en-de/mens-swim-shorts-cold-green",
    product_description: "The Swim Shorts",
    item_image: "https://images.asket.com/pim-images/1755180235-asket_sws-mc-cdg_thumbnail.jpg"
  }
]

asket_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = asket_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{asket_products.length} ASKET products"

# MUD Jeans Products
mud_jeans_products = [
  {
    clothing_item: "Jeans",
    clothing_material: "40% post-consumer recycled cotton,\n60% organic cotton",
    clothing_colour: "Light Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 139.95,
    external_link: "https://mudjeans.com/products/alex-mid-loose-light-stone",
    product_description: "Alex Mid Loose - Light Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-alex-mid-loose-light-stone-full-body-front-summer-2_96364c98-4f94-477f-9281-274994515ad2.jpg?v=1764679860&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Rustic Blue",
    clothing_brand: "MUD Jeans",
    clothing_price: 139.95,
    external_link: "https://mudjeans.com/products/bryce-mid-straight-rustic-blue",
    product_description: "Bryce Mid Straight - Rustic Blue",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-bryce-mid-straight-rustic-blue-full-body-front-winter.jpg?v=1747398170&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "79%organic cotton,\n20% post-consumer recycled denim,\n1% recycled elastane",
    clothing_colour: "Medium Heritage",
    clothing_brand: "MUD Jeans",
    clothing_price: 199.95,
    external_link: "https://mudjeans.com/products/hank-mid-tapered-medium-heritage",
    product_description: "Hank Mid Tapered - Medium Heritage",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-hank-mid-tapered-medium-heritage-full-body-front-winter-2.jpg?v=1746189089&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "03 Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 83.97,
    external_link: "https://mudjeans.com/products/dunn-low-tapered-03-grey",
    product_description: "Dunn Low Tapered - 03 Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-dunn-low-tapered-03-grey-full-body-front-winter.jpg?v=1764680141&width=2453"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Heather Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 44.98,
    external_link: "https://mudjeans.com/products/ty-sweatshirt-grey",
    product_description: "Ty Sweatshirt - Heather Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-sweatshirts-ty-sweatshirt-heather-grey-half-body-front.jpg?v=1745326318&width=2417"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 53.97,
    external_link: "https://mudjeans.com/products/ty-sweatshirt-black",
    product_description: "Ty Sweatshirt - Black",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-sweatshirts-ty-sweatshirt-black-half-body-front-2.jpg?v=1745324672&width=2417"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Heather Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 24.98,
    external_link: "https://mudjeans.com/products/robin-tee-grey",
    product_description: "Robin Tee - Heather Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-tshirts-robin-tee-heather-grey-full-body-front.jpg?v=1764680413&width=2417"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 24.98,
    external_link: "https://mudjeans.com/products/robin-tee-black",
    product_description: "Robin Tee - Black",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-tshirts-robin-tee-black-half-body-front.jpg?v=1745506276&width=2417"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "White",
    clothing_brand: "MUD Jeans",
    clothing_price: 29.97,
    external_link: "https://mudjeans.com/products/robin-tee-white",
    product_description: "Robin Tee - White",
    item_image: "https://mudjeans.com/cdn/shop/files/2_38bbbb2c-9f8b-4a55-8132-9e6b5297c38c.jpg?v=1764680421&width=788"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "75% organic cotton,\n23% post-consumer recycled cotton,\n2% elastane",
    clothing_colour: "True Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 90.95,
    external_link: "https://mudjeans.com/products/slimmer-rick-true-indigo",
    product_description: "Slimmer Rick - True Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/MB0022S001_D002_1.jpg?v=1748351323&width=467"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "79%organic cotton,\n20% post-consumer recycled denim,\n1% recycled elastane",
    clothing_colour: "Dip Dry",
    clothing_brand: "MUD Jeans",
    clothing_price: 119.97,
    external_link: "https://mudjeans.com/products/hank-mid-tapered-dip-dry",
    product_description: "Hank Mid Tapered - Dip Dry",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-hank-mid-tapered-dip-dry-full-body-front-summer_b53003d8-7139-48fe-af60-22171a17d562.jpg?v=1746697168&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n75% organic cotton,&nbsp;\n3% LYCRA® T400® Ecomade,\n2% elastane",
    clothing_colour: "Authentic Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 90.97,
    external_link: "https://mudjeans.com/products/rick-mid-slim-authentic-black",
    product_description: "Rick Mid Slim - Authentic Black",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-rick-mid-slim-authentic-black-full-body-front-summer.jpg?v=1764680172&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "57% recycled cotton,\n20% organic cotton,\n21% TENCEL™ Lyocell x REFIBRA™",
    clothing_colour: "Medium Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.97,
    external_link: "https://mudjeans.com/products/john-mid-straight-medium-black",
    product_description: "John Mid Straight - Medium Black",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-john-mid-straight-medium-black-full-body-front-summer_e72c6727-c092-46ee-9148-f9976ad7eeb2.jpg?v=1764679953&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n79% organic cotton,\n1% elastane",
    clothing_colour: "Stone Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.97,
    external_link: "https://mudjeans.com/products/isy-high-flared-stone-indigo",
    product_description: "Isy High Flared - Stone Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-isy-high-flared-stone-indigo-full-body-front-summer.jpg?v=1747917637&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Old Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.98,
    external_link: "https://mudjeans.com/products/daily-mid-tapered-old-stone",
    product_description: "Daily Mid Tapered - Old Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-daily-mid-tapered-old-stone-full-body-front-winter.jpg?v=1764680125&width=2453"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Medium Dark",
    clothing_brand: "MUD Jeans",
    clothing_price: 90.97,
    external_link: "https://mudjeans.com/products/bryce-mid-straight-medium-dark",
    product_description: "Bryce Mid Straight - Medium Dark",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-bryce-mid-straight-medium-dark-full-body-front-winter.jpg?v=1746195855&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "40% post-consumer recycled cotton,\n60% organic cotton",
    clothing_colour: "Medium Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.97,
    external_link: "https://mudjeans.com/products/john-mid-straight-medium-stone",
    product_description: "John Mid Straight - Medium Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-john-mid-straight-medium-stone-full-body-front-winter_e7331d37-539f-432e-8fb4-6e1909fc6b10.jpg?v=1763109536&width=2453"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "74% organic cotton,\n24% pre-consumer recycled cotton,\n2% elastane",
    clothing_colour: "Authentic Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.97,
    external_link: "https://mudjeans.com/products/bryce-mid-straight-authentic-indigo",
    product_description: "Bryce Mid Straight - Authentic Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/bryceauthenticindigo_fullbodymen_JpgHighres_3.jpg?v=1764930656&width=1700"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Stone Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.97,
    external_link: "https://mudjeans.com/products/isy-high-flared-stone-black",
    product_description: "Isy High Flared - Stone Black",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-isy-high-flared-stone-black-full-body-front-summer.jpg?v=1737128396&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "57% recycled cotton,\n20% organic cotton,\n21% TENCEL™ Lyocell x REFIBRA™",
    clothing_colour: "Nero Nero",
    clothing_brand: "MUD Jeans",
    clothing_price: 149.95,
    external_link: "https://mudjeans.com/products/sara-high-loose-nero-nero",
    product_description: "Sara High Loose - Nero Nero",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-nero-nero-full-body-front-winter.jpg?v=1738167995&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "57% recycled cotton,\n20% organic cotton,\n21% TENCEL™ Lyocell x REFIBRA™,\n2% other fibres",
    clothing_colour: "Stone Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 83.97,
    external_link: "https://mudjeans.com/products/john-mid-straight-stone-indigo",
    product_description: "John Mid Straight - Stone Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-john-mid-straight-stone-indigo-full-body-front-summer_6f52e5e7-d276-4210-a00f-58fa96f59de9.jpg?v=1746189732&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Stone Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.98,
    external_link: "https://mudjeans.com/products/daily-mid-tapered-stone-indigo",
    product_description: "Daily Mid Tapered - Stone Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-daily-mid-tapered-stone-indigo-full-body-front-winter.jpg?v=1738154977&width=2453"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton,\nWeight 9,25 oz",
    clothing_colour: "Sand",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.98,
    external_link: "https://mudjeans.com/products/sara-high-loose-flow-sand",
    product_description: "Sara High Loose Flow - Sand",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-sand-full-body-front-summer.jpg?v=1741614109&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton,\nWeight 9,25 oz",
    clothing_colour: "Natural",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.98,
    external_link: "https://mudjeans.com/products/sara-high-loose-flow-natural",
    product_description: "Sara High Loose Flow - Natural",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-natural-full-body-front-summer.jpg?v=1741617533&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "5% recycled cotton,\n80% organic cotton",
    clothing_colour: "Dry",
    clothing_brand: "MUD Jeans",
    clothing_price: 113.97,
    external_link: "https://mudjeans.com/products/bryce-mid-straight-dry",
    product_description: "Bryce Mid Straight - Dry",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-bryce-mid-straight-dip-dry-full-body-front.jpg?v=1745323777&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "75% organic cotton,\n23% post-consumer recycled cotton,\n2% elastane",
    clothing_colour: "Fan Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.95,
    external_link: "https://mudjeans.com/products/isy-flared-fan-stone",
    product_description: "Isy Flared - Fan Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/ISYEDIT1-2.jpg?v=1751553688&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "75% organic cotton,\n23% post-consumer recycled cotton,\n2% elastane",
    clothing_colour: "O3 Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.95,
    external_link: "https://mudjeans.com/products/isy-flared-o3-grey",
    product_description: "Isy Flared - O3 Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/IsyStoneBlack_Front_Fullbody-4.jpg?v=1753273407&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "40% post-consumer recycled cotton,\n60% organic cotton",
    clothing_colour: "Medium Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.95,
    external_link: "https://mudjeans.com/products/emma-low-loose-medium-stone",
    product_description: "Emma Low Loose - Medium Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-emma-low-loose-medium-stone-half-body-front-winter.jpg?v=1750077765&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Light Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 83.97,
    external_link: "https://mudjeans.com/products/rick-mid-slim-light-grey",
    product_description: "Rick Mid Slim - Light Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-rick-mid-slim-light-grey-full-body-front-summer.jpg?v=1746189923&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% organic cotton,\n20% post-consumer recycled denim",
    clothing_colour: "Marge Grey",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.98,
    external_link: "https://mudjeans.com/products/sara-high-loose-flow-marge-grey",
    product_description: "Sara High Loose Flow - Marge Grey",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-marge-grey-full-body-front-summer-4.jpg?v=1746608355&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "57% recycled cotton,\n20% organic cotton,\n21% TENCEL™ Lyocell x REFIBRA™",
    clothing_colour: "Dry Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 64.98,
    external_link: "https://mudjeans.com/products/go-mid-straight-dry-black",
    product_description: "Go Mid Straight - Dry Black",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-go-mid-straight-dry-black-full-body-front-summer-5.jpg?v=1748337909&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% organic cotton,\nWeight 9,25 oz",
    clothing_colour: "Olive",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.97,
    external_link: "https://mudjeans.com/products/sara-high-loose-flow-olive",
    product_description: "Sara High Loose Flow - Olive",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-olive-full-body-front-winter.jpg?v=1738239943&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "27% organic cotton,\n25% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Light Vintage",
    clothing_brand: "MUD Jeans",
    clothing_price: 104.97,
    external_link: "https://mudjeans.com/products/hank-mid-tapered-light-vintage",
    product_description: "Hank Mid Tapered - Light Vintage",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-hank-mid-tapered-light-vintage-full-front-back-winter.jpg?v=1746188604&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n30% hemp,\n50% organic cotton",
    clothing_colour: "Sun Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 90.95,
    external_link: "https://mudjeans.com/products/wyde-sara-sun-stone",
    product_description: "Wyde Sara - Sun Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/Sara-SunStone-Front-3.jpg?v=1751553746&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n75% organic cotton,\n3% LYCRA® T400® Ecomade,\n2% elastane",
    clothing_colour: "Stone Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.97,
    external_link: "https://mudjeans.com/products/faye-low-slim-stone-indigo",
    product_description: "Faye Low Slim - Stone Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-faye-low-slim-stone-indigo-full-body-front-summer.jpg?v=1737126077&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n79% organic cotton,\n1% elastane",
    clothing_colour: "Strong Blue",
    clothing_brand: "MUD Jeans",
    clothing_price: 77.95,
    external_link: "https://mudjeans.com/products/regular-swan-strong-blue",
    product_description: "Regular Swan - Strong Blue",
    item_image: "https://mudjeans.com/cdn/shop/files/MUD-Jeans-Women-Regular-Swan-Strong-Blue-2.jpg?v=1750077516&width=1800"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "78% organic cotton,\n21% post-consumer recycled cotton,\n2% recycled elastane",
    clothing_colour: "Medium Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 89.97,
    external_link: "https://mudjeans.com/products/hank-mid-tapered-medium-stone",
    product_description: "Hank Mid Tapered - Medium Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/men-sustainable-jeans-hank-mid-tapered-medium-stone-full-body-front.jpg?v=1746699793&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n75% organic cotton,\n3% LYCRA® T400® Ecomade,\n2% elastane",
    clothing_colour: "Sunny Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 64.98,
    external_link: "https://mudjeans.com/products/faye-low-slim-sunny-stone",
    product_description: "Faye Low Slim - Sunny Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-faye-low-slim-sunny-stone-full-body-front-winter.jpg?v=1738243357&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "42% organic cotton,\n30% TENCEL™ Lyocell x REFIBRA™,\n25% pre-consumer recycled cotton,\n3% elastane",
    clothing_colour: "Sand",
    clothing_brand: "MUD Jeans",
    clothing_price: 89.95,
    external_link: "https://mudjeans.com/products/chelsea-mid-loose-sand",
    product_description: "Chelsea Mid Loose - Sand",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-chelsea-mid-loose-sand-half-body-front-summer_90b92ff1-41a1-4a37-9884-070169303611.jpg?v=1751535331&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% organic cotton,\n20% post-consumer recycled denim",
    clothing_colour: "Natural",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.95,
    external_link: "https://mudjeans.com/products/sara-high-loose-natural",
    product_description: "Sara High Loose - Natural",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-sara-high-loose-natural-fullfront_561eb97c-698c-4c7f-94f7-b491837bb192.jpg?v=1738250877&width=2417"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "20% post-consumer recycled denim,\n20% pre-consumer recycled linen,\n60% organic cotton",
    clothing_colour: "Stone Indigo",
    clothing_brand: "MUD Jeans",
    clothing_price: 69.97,
    external_link: "https://mudjeans.com/products/gloria-shirt-stone-indigo",
    product_description: "Gloria Shirt - Stone Indigo",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-shirts-gloria-denim-shirt-stone-indigo-half-body-front-summer.jpg?v=1738744966&width=2417"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 44.98,
    external_link: "https://mudjeans.com/products/clara-sweatshirt-black",
    product_description: "Clara Sweatshirt - Black",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-sweatshirts-clara-sweatshirt-black-half-body-front-2.jpg?v=1745325010&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "20% post-consumer recycled cotton,\n60% organic cotton,\n20% pre-consumer recycled linen",
    clothing_colour: "Stone Vintage",
    clothing_brand: "MUD Jeans",
    clothing_price: 97.95,
    external_link: "https://mudjeans.com/products/max-loose-flow-stone-vintage",
    product_description: "Max Loose Flow - Stone Vintage",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-skirts-max-loose-flow-skirt-stone-vintage-full-body-front-summer.jpg?v=1745934658&width=2417"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "80% organic cotton,\n20% post-consumer recycled denim",
    clothing_colour: "Medium Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 83.95,
    external_link: "https://mudjeans.com/products/reese-denim-shirt-medium-stone",
    product_description: "Reese Denim Shirt - Medium Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-shirts-reese-denim-shirt-medium-stone-half-body-front-winter.jpg?v=1738247754&width=2417"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "100% organic cotton",
    clothing_colour: "Natural",
    clothing_brand: "MUD Jeans",
    clothing_price: 44.98,
    external_link: "https://mudjeans.com/products/clara-sweatshirt-natural",
    product_description: "Clara Sweatshirt - Natural",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-sweatshirts-clara-sweatshirt-natural-half-body-front.jpg?v=1745325745&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% organic cotton,\n20% post-consumer recycled denim",
    clothing_colour: "BlackDip",
    clothing_brand: "MUD Jeans",
    clothing_price: 118.95,
    external_link: "https://mudjeans.com/products/ella-denim-dress-blackdip",
    product_description: "Ella Denim Dress - BlackDip",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-jeans-faye-low-slim-stone-black-full-body-front2-winter.jpg?v=1738243115&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "80% organic cotton,\n20% post-consumer recycled denim",
    clothing_colour: "Sun Stone",
    clothing_brand: "MUD Jeans",
    clothing_price: 118.95,
    external_link: "https://mudjeans.com/products/ella-denim-dress-sun-stone",
    product_description: "Ella Denim Dress - Sun Stone",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-dresses-ella-denim-dress-sun-stone-full-body-front-winter.jpg?v=1738230752&width=2417"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "57% recycled cotton,\n20% organic cotton,\n21% TENCEL™ Lyocell x REFIBRA™",
    clothing_colour: "Dry Black",
    clothing_brand: "MUD Jeans",
    clothing_price: 84.98,
    external_link: "https://mudjeans.com/products/gina-jacket-dry-black",
    product_description: "Gina Jacket - Dry Black",
    item_image: "https://mudjeans.com/cdn/shop/files/WL13GOBLACK_Fullbodywomen_JpgHighres_31.jpg?v=1751555446&width=2417"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "40% post-consumer recycled cotton,\n60% organic cotton",
    clothing_colour: "Stone Vintage",
    clothing_brand: "MUD Jeans",
    clothing_price: 59.95,
    external_link: "https://mudjeans.com/products/tess-top-stone-vintage",
    product_description: "Tess Top - Stone Vintage",
    item_image: "https://mudjeans.com/cdn/shop/files/women-sustainable-tops-tess-top-stone-vintage-half-body-front.jpg?v=1738744949&width=2417"
  }
]

mud_jeans_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = mud_jeans_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{mud_jeans_products.length} MUD Jeans products"

# Lululemon Products
lululemon_products = [
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 0.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Love-Crew/_/prod8350092?color=0001&ta=1&taterm=t-shirt&tasid=AmxcsphRHM",
    product_description: "Love Crewneck T-ShirtWomen's Short Sleeve Shirts",
    item_image: "https://shop.lululemon.com/data:,"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 0.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Swiftly-Tech-SS-2/_/prod9750519?color=4780&ta=1&taterm=t-shirt&tasid=AmxcsphRHM",
    product_description: "Swiftly Tech Short-Sleeve Shirt 2.0 *Hip LengthWomen's Short Sleeve Shirts",
    item_image: "https://shop.lululemon.com/data:,"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 0.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Relaxed-Fit-Cotton-Jersey-T-Shirt-Wordmark-MD/_/prod11790008?color=0001&ta=1&taterm=t-shirt&tasid=AmxcsphRHM",
    product_description: "Relaxed-Fit Cotton Jersey T-Shirt *WordmarkWomen's Short Sleeve Shirts",
    item_image: "https://shop.lululemon.com/data:,"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 0.0,
    external_link: "https://shop.lululemon.com/p/men-ss-tops/Organic-Cotton-Classic-Fit-T-Shirt/_/prod11680617?color=68578&ta=1&taterm=t-shirt&tasid=AmxcsphRHM",
    product_description: "Organic Cotton Classic-Fit T-ShirtMen's Short Sleeve Shirts",
    item_image: "https://shop.lululemon.com/data:,"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 128.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Define-Jacket-Nulu/_/prod11020158?color=30437",
    product_description: "Define Jacket Nulu",
    item_image: "https://images.lululemon.com/is/image/lululemon/30437"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 38.0,
    external_link: "https://shop.lululemon.com/p/bags/Everywhere-Belt-Bag/_/prod8900747?color=0614",
    product_description: "Everywhere Belt Bag 1L",
    item_image: "https://images.lululemon.com/is/image/lululemon/0614"
  },
  {
    clothing_item: "Leggings",
    clothing_material: "Unknown",
    clothing_colour: "Graphite Grey",
    clothing_brand: "Lululemon",
    clothing_price: 49.0,
    external_link: "https://shop.lululemon.com/p/womens-leggings/Wunder-Under-SmoothCover-HR-Tight-28-MD/_/prod11690020?color=30210",
    product_description: "Wunder Under SmoothCover High-Rise Tight 28\"",
    item_image: "https://images.lululemon.com/is/image/lululemon/30210"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 48.0,
    external_link: "https://shop.lululemon.com/p/bags/Dual-Pouch-Wristlet/_/prod10930207?color=75553",
    product_description: "Dual Pouch Wristlet",
    item_image: "https://images.lululemon.com/is/image/lululemon/75553"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 84.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Define-Jacket-Nulu-MD/_/prod11210211?color=71926",
    product_description: "Define Jacket Nulu",
    item_image: "https://images.lululemon.com/is/image/lululemon/71926"
  },
  {
    clothing_item: "Sweater",
    clothing_material: "Unknown",
    clothing_colour: "Fog Green",
    clothing_brand: "Lululemon",
    clothing_price: 84.0,
    external_link: "https://shop.lululemon.com/p/womens-outerwear/Scuba-Oversized-12-Zip-Hoodie-MD/_/prod10300103?color=70144",
    product_description: "Scuba Oversized Half-Zip Hoodie",
    item_image: "https://images.lululemon.com/is/image/lululemon/70144"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 128.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Nulu-Cropped-Define-Jacket/_/prod10930188?color=72761",
    product_description: "Define Cropped Jacket Nulu",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Leggings",
    clothing_material: "Unknown",
    clothing_colour: "Black",
    clothing_brand: "Lululemon",
    clothing_price: 49.0,
    external_link: "https://shop.lululemon.com/p/womens-leggings/Wunder-Under-SmoothCover-HR-Tight-25-MD/_/prod11680115?color=0001",
    product_description: "Wunder Under SmoothCover High-Rise Tight 25\"",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 118.0,
    external_link: "https://shop.lululemon.com/p/womens-leggings/Groove-Nulu-High-Rise-Flared-Pant-Regular/_/prod11871437?color=72756",
    product_description: "Groove Nulu High-Rise Flared Pant Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/72756"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 98.0,
    external_link: "https://shop.lululemon.com/p/womens-joggers/BeCalm-Oversized-Mid-Rise-Pant/_/prod20000711?color=72761",
    product_description: "BeCalm Oversized Mid-Rise Pant",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 118.0,
    external_link: "https://shop.lululemon.com/p/womens-sweatpants/BeCalm-High-Rise-Pleated-Extra-Wide-Leg-Pant/_/prod20000727?color=72761",
    product_description: "BeCalm High-Rise Pleated Extra-Wide Leg Pant",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Olive Brown",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-sweatpants/Softstreme-Pintuck-HR-Wide-Leg-Pant-Reg/_/prod20006083?color=71148",
    product_description: "Softstreme Pintuck High-Rise Wide-Leg Pant Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/71148"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-High-Rise-Wide-Leg-Trouser-Short/_/prod11870757?color=30210",
    product_description: "Daydrift High-Rise Wide-Leg Trouser Short",
    item_image: "https://images.lululemon.com/is/image/lululemon/30210"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Heathered Herringbone Heathered Nutmeg Light Ivory",
    clothing_brand: "Lululemon",
    clothing_price: 158.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-HR-Wide-Trouser-Short-Herringbone/_/prod20007195?color=72748",
    product_description: "Daydrift High-Rise Wide-Leg Trouser Short Herringbone",
    item_image: "https://images.lululemon.com/is/image/lululemon/72748"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Heathered Herringbone Heathered Deep Coal Black",
    clothing_brand: "Lululemon",
    clothing_price: 158.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-HR-Wide-Leg-Trouser-R-Herringbone/_/prod20006035?color=72747",
    product_description: "Daydrift High-Rise Wide-Leg Trouser Regular Herringbone",
    item_image: "https://images.lululemon.com/is/image/lululemon/72747"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Luxe Shine Foil Print True Navy",
    clothing_brand: "Lululemon",
    clothing_price: 138.0,
    external_link: "https://shop.lululemon.com/p/women-pants/Dance-Studio-Mid-Rise-Pant-Shine/_/prod20006279?color=72730",
    product_description: "Dance Studio Mid-Rise Pant Shine",
    item_image: "https://images.lululemon.com/is/image/lululemon/72730"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-High-Rise-Wide-Leg-Trouser-Regular/_/prod11860288?color=72761",
    product_description: "Daydrift High-Rise Wide-Leg Trouser Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-High-Rise-Straight-Leg-Trouser-Regular/_/prod20005567?color=72761",
    product_description: "Daydrift High-Rise Straight-Leg Trouser Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-trousers/Daydrift-High-Rise-Tapered-Trouser-Regular/_/prod20002107?color=0001",
    product_description: "Daydrift High-Rise Tapered Trouser Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-joggers/Daydrift-High-Rise-Jogger-Regular/_/prod20002923?color=41179",
    product_description: "Daydrift High-Rise Jogger Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/41179"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 118.0,
    external_link: "https://shop.lululemon.com/p/womens-joggers/lululemon-Align-High-Rise-Jogger-Regular/_/prod20002011?color=0001",
    product_description: "lululemon Align™ High-Rise Jogger Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "True Navy",
    clothing_brand: "Lululemon",
    clothing_price: 128.0,
    external_link: "https://shop.lululemon.com/p/women-pants/lululemon-Align-Palazzo-Pant-Regular/_/prod11871062?color=31382",
    product_description: "lululemon Align™ Palazzo Pant Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/31382"
  },
  {
    clothing_item: "Sweater",
    clothing_material: "Unknown",
    clothing_colour: "Heathered Core Medium Grey",
    clothing_brand: "Lululemon",
    clothing_price: 118.0,
    external_link: "https://shop.lululemon.com/p/womens-sweatpants/Scuba-MR-Wide-Leg-Pant-Regular/_/prod11750327?color=31045",
    product_description: "Scuba Mid-Rise Wide-Leg Pant Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/31045"
  },
  {
    clothing_item: "Sweater",
    clothing_material: "Unknown",
    clothing_colour: "Heathered Faint Lavender",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/womens-sweatpants/Scuba-Mid-Rise-Wide-Leg-Pant-Waffle/_/prod20004467?color=42362",
    product_description: "Scuba Mid-Rise Wide-Leg Pant Waffle",
    item_image: "https://images.lululemon.com/is/image/lululemon/42362"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Black",
    clothing_brand: "Lululemon",
    clothing_price: 138.0,
    external_link: "https://shop.lululemon.com/p/womens-joggers/Adapted-State-Training-Jogger-Fleece/_/prod10690025?color=63787",
    product_description: "Adapted State High-Rise Fleece Jogger Full Length",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 138.0,
    external_link: "https://shop.lululemon.com/p/women-pants/Court-Rival-Mid-Rise-Wide-Track-Pant-Reg-Stitch/_/prod20000511?color=0023",
    product_description: "Court Rival Wide-Leg Track Pant Regular Stitched Logo",
    item_image: "https://images.lululemon.com/is/image/lululemon/0023"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "Black",
    clothing_brand: "Lululemon",
    clothing_price: 128.0,
    external_link: "https://shop.lululemon.com/p/womens-leggings/Groove-High-Rise-Flared-Pant-Warm/_/prod20003055?color=0001",
    product_description: "Groove High-Rise Flared Pant Warm",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Pants",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 128.0,
    external_link: "https://shop.lululemon.com/p/women-pants/Dance-Studio-Pant-MR-Reg/_/prod11530198?color=63787",
    product_description: "Dance Studio Mid-Rise Pant Regular",
    item_image: "https://images.lululemon.com/is/image/lululemon/63787"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/Ebb-To-Street-Scoop-Neck-Crop-Tank-B-C/_/prod11710404?color=74077",
    product_description: "Ebb to Street Scoop-Neck Cropped Tank Top Light Support, B/C Cup",
    item_image: "https://images.lululemon.com/is/image/lululemon/74077"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/Align-Tank/_/prod9600539?color=72756",
    product_description: "lululemon Align™ Tank Top Light Support, A/B Cup",
    item_image: "https://images.lululemon.com/is/image/lululemon/72756"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 58.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/Align-WaistLength-Racerback-Tank/_/prod10930183?color=74028",
    product_description: "lululemon Align™ Waist-Length Racerback Tank Top",
    item_image: "https://images.lululemon.com/is/image/lululemon/74028"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Dilute Wash Sky Fall",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/EasySet-Short-Sleeve-Shirt-Wash/_/prod20006403?color=72651",
    product_description: "EasySet Short-Sleeve Shirt Wash",
    item_image: "https://images.lululemon.com/is/image/lululemon/72651"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Porcelain Pink",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/lululemon-Align-High-Neck-Tank-Top/_/prod10760085?color=30437",
    product_description: "lululemon Align™ High-Neck Tank Top Light Support",
    item_image: "https://images.lululemon.com/is/image/lululemon/30437"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 48.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Love-Crew/_/prod8350092?color=76130",
    product_description: "Love Crewneck T-Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/76130"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 48.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Love-Tee-V/_/prod8351148?color=76130",
    product_description: "Love V-Neck T-Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/76130"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Dilute Wash Graphite Grey",
    clothing_brand: "Lululemon",
    clothing_price: 78.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/EasySet-Relaxed-Long-Sleeve-Shirt-Wash/_/prod20005499?color=66559",
    product_description: "EasySet Relaxed Long-Sleeve Shirt Wash",
    item_image: "https://images.lululemon.com/is/image/lululemon/66559"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 58.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Love-Long-Sleeve/_/prod10550097?color=72757",
    product_description: "Love Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/72757"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Black",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Wunder-Train-Off-Shoulder-Long-Sleeve-Shirt/_/prod20009055?color=0001",
    product_description: "Wunder Train Off-Shoulder Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Hold-Tight-Long-Sleeve/_/prod10641672?color=45797",
    product_description: "Hold Tight Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/45797"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 78.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Swiftly-Tech-LS-2-Race/_/prod9750541?color=73617",
    product_description: "Swiftly Tech Long-Sleeve Shirt 2.0 Waist Length",
    item_image: "https://images.lululemon.com/is/image/lululemon/73617"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "s",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/tops-short-sleeve/Swiftly-Tech-SS-2/_/prod9750519?color=73086",
    product_description: "Swiftly Tech Short-Sleeve Shirt 2.0 Hip Length",
    item_image: "https://images.lululemon.com/is/image/lululemon/73086"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Ashen Rose",
    clothing_brand: "Lululemon",
    clothing_price: 48.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/Jersey-Training-Tank-Top/_/prod11750258?color=45797",
    product_description: "Jersey Training Tank Top",
    item_image: "https://images.lululemon.com/is/image/lululemon/45797"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 78.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/BeCalm-V-Neck-Bell-Sleeve-Shirt/_/prod20005779?color=72761",
    product_description: "BeCalm V-Neck Bell Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 88.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/BeCalm-Oversized-Boatneck-Long-Sleeve-Shirt/_/prod20004283?color=72761",
    product_description: "BeCalm Oversized Boatneck Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Downtown Tan",
    clothing_brand: "Lululemon",
    clothing_price: 78.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Wundermost-Ult-Soft-Nulu-Crwnck-LS-Shirt/_/prod11570037?color=72762",
    product_description: "Wundermost Ultra-Soft Nulu Crewneck Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/72762"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 88.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/BeCalm-Wrap-Front-Long-Sleeve-Shirt/_/prod20004755?color=72761",
    product_description: "BeCalm Wrap-Front Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Walnut Crunch",
    clothing_brand: "Lululemon",
    clothing_price: 68.0,
    external_link: "https://shop.lululemon.com/p/women-tanks/lululemon-Align-Twist-Strap-Cropped-Tank-Top-LS-BC/_/prod20004923?color=72761",
    product_description: "lululemon Align™ Twist-Strap Cropped Tank Top Light Support, B/C Cup",
    item_image: "https://images.lululemon.com/is/image/lululemon/72761"
  },
  {
    clothing_item: "Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Unknown",
    clothing_brand: "Lululemon",
    clothing_price: 78.0,
    external_link: "https://shop.lululemon.com/p/tops-long-sleeve/Swiftly-Open-Hole-V-Neck-Long-Sleeve-Shirt/_/prod20001611?color=73085",
    product_description: "Swiftly Open-Hole V-Neck Long-Sleeve Shirt",
    item_image: "https://images.lululemon.com/is/image/lululemon/73085"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Light Ivory",
    clothing_brand: "Lululemon",
    clothing_price: 448.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Womens-Wunder-Puff-Jacket-Long/_/prod9960898?color=33454",
    product_description: "Women's Wunder Puff 600-Down-Fill Long Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/33454"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Polyester",
    clothing_colour: "Porcelain Pink",
    clothing_brand: "Lululemon",
    clothing_price: 348.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Wunder-Puff-Jacket/_/prod9490219?color=30437",
    product_description: "Women's Wunder Puff 600-Down-Fill Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/30437"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Unknown",
    clothing_colour: "Light Ivory",
    clothing_brand: "Lululemon",
    clothing_price: 268.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Wunder-Puff-Crop-Vest/_/prod9960896?color=33454",
    product_description: "Wunder Puff 600-Down-Fill Cropped Vest",
    item_image: "https://images.lululemon.com/is/image/lululemon/33454"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Polyester\nCare\nMachine Wash Cold\nDo Not Bleach\nTumble Dry Low\nDo Not Iron\nD",
    clothing_colour: "Black",
    clothing_brand: "Lululemon",
    clothing_price: 248.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Rain-Rebel-Jacket/_/prod9280037?color=0001",
    product_description: "Rain Rebel Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/0001"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Black Plum",
    clothing_brand: "Lululemon",
    clothing_price: 228.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/W-Cross-Chill-Performance-Jacket/_/prod9750597?color=34697",
    product_description: "Women's Cross Chill Performance Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/34697"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Grape Mist",
    clothing_brand: "Lululemon",
    clothing_price: 268.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Cross-Chill-Cinch-Back-Casual-Jacket/_/prod20005143?color=0554",
    product_description: "Cross Chill Cinch-Back Casual Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/0554"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Light Ivory",
    clothing_brand: "Lululemon",
    clothing_price: 398.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Waterproof-Insulated-Cinch-Waist-Parka/_/prod20006807?color=33454",
    product_description: "Waterproof Insulated Cinch-Waist Parka",
    item_image: "https://images.lululemon.com/is/image/lululemon/33454"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Porcelain Pink",
    clothing_brand: "Lululemon",
    clothing_price: 148.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Always-Effortless-Classic-Fit-Jacket/_/prod9370052?color=30437",
    product_description: "Always Effortless Classic-Fit Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/30437"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "Unknown",
    clothing_colour: "Onyx Grey",
    clothing_brand: "Lululemon",
    clothing_price: 228.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Another-Mile-Jacket/_/prod11680480?color=72760",
    product_description: "Another Mile Jacket",
    item_image: "https://images.lululemon.com/is/image/lululemon/72760"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "Unknown",
    clothing_colour: "Onyx Grey",
    clothing_brand: "Lululemon",
    clothing_price: 168.0,
    external_link: "https://shop.lululemon.com/p/jackets-and-hoodies-jackets/Another-Mile-Vest/_/prod9750593?color=72760",
    product_description: "Another Mile Vest",
    item_image: "https://images.lululemon.com/is/image/lululemon/72760"
  }
]

lululemon_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = lululemon_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{lululemon_products.length} Lululemon products"

# Etiko Products
etiko_products = [
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Black",
    clothing_brand: "Etiko",
    clothing_price: 22.95,
    external_link: "https://etiko.com.au/products/fairtrade-organic-cotton-black-tshirt-unisex",
    product_description: "Round Neck T-shirt, Unisex Black",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ROUND_NECK_T-SHIRT_UNISEX_BLACK.jpg?v=1736981941&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Charcoal",
    clothing_brand: "Etiko",
    clothing_price: 22.95,
    external_link: "https://etiko.com.au/products/fairtrade-organic-cotton-charcoal-tshirt-unisex",
    product_description: "Round Neck T-shirt, Unisex Charcoal",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ROUND_NECK_T-SHIRT_UNISEX_CHARCOAL.jpg?v=1736981940&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "White",
    clothing_brand: "Etiko",
    clothing_price: 22.95,
    external_link: "https://etiko.com.au/products/fairtrade-organic-cotton-white-tshirt-unisex",
    product_description: "Round Neck T-shirt, Unisex White",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ROUND_NECK_TSHIRT_UNISEX_WHITE.jpg?v=1736981978&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Navy",
    clothing_brand: "Etiko",
    clothing_price: 22.95,
    external_link: "https://etiko.com.au/products/fairtrade-organic-cotton-navy-tshirt-unisex",
    product_description: "Round Neck T-shirt, Unisex Navy",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ROUND_NECK_TSHIRT_UNISEX_NAVY.jpg?v=1736981966&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Grey Marle",
    clothing_brand: "Etiko",
    clothing_price: 22.95,
    external_link: "https://etiko.com.au/products/fairtrade-organic-cotton-grey-tshirt-unisex",
    product_description: "Round Neck T-shirt, Unisex Grey Marle",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ROUND_NECK_TSHIRT_UNISEX_GREY_MARLE.jpg?v=1736981968&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Fairtrade Organic Cotton",
    clothing_colour: "Black",
    clothing_brand: "Etiko",
    clothing_price: 9.95,
    external_link: "https://etiko.com.au/products/organic-fairtrade-black-tshirt-unisex-refujesus",
    product_description: "REFUJESUS PRINTED T-SHIRT, UNISEX BLACK",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_REFUJESUS_PRINTED_UNISEX_TSHIRT_BLACK.jpg?v=1736981906&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Blue Marle",
    clothing_brand: "Etiko",
    clothing_price: 9.95,
    external_link: "https://etiko.com.au/products/tshirt-unisex-less-plastic-more-love-blue-marle-organic-fairtrade",
    product_description: "Less Plastic More Love Printed T-shirt, Unisex Blue Marle",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_LESS_PLASTIC_MORE_LOVE_PRINTED_UNISEX_TSHIRT_BLUE_MARLE.png?v=1736981865&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Navy",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-vneck-unisex-navy-blue-organic-fairtrade",
    product_description: "V-Neck T-shirt, Unisex Navy",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_VNECK_TSHIRT_UNISEX_NAVY.jpg?v=1736981932&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Grey Marle",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-vneck-unisex-grey-marle-organic-fairtrade",
    product_description: "V-Neck T-shirt, Unisex Grey Marle",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_VNECK_TSHIRT_UNISEX_GREY_MARLE.jpg?v=1736981933&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Black",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-vneck-unisex-black-organic-fairtrade",
    product_description: "V-Neck T-shirt, Unisex Black",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_VNECK_TSHIRT_UNISEX_BLACK.jpg?v=1736981937&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "White",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-vneck-unisex-white-organic-fairtrade",
    product_description: "V-Neck T-shirt, Unisex White",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_VNECK_TSHIRT_UNISEX_WHITE.jpg?v=1736981930&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Fairtrade Organic Cotton",
    clothing_colour: "Charcoal",
    clothing_brand: "Etiko",
    clothing_price: 9.95,
    external_link: "https://etiko.com.au/products/tshirt-unisex-beard-charcoal-organic-fairtrade",
    product_description: "Zoo Beard Printed T-Shirt, Unisex Charcoal",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_ZOO_BEARD_PRINTED_UNISEX_TSHIRT_CHARCOAL.jpg?v=1736981935&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Grey Marle",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-longsleeve-unisex-grey-marle-organic-fairtrade",
    product_description: "Long Sleeve T-shirt, Unisex Grey Marle",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_LONG_SLEEVE_TSHIRT_UNISEX_GREY_MARLE.png?v=1736981922&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Navy",
    clothing_brand: "Etiko",
    clothing_price: 6.95,
    external_link: "https://etiko.com.au/products/tshirt-longsleeve-unisex-navy-blue-organic-fairtrade",
    product_description: "Long Sleeve T-shirt, Unisex Navy",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_LONG_SLEEVE_TSHIRT_UNISEX_NAVY.png?v=1736981920&width=1946"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "Fairtrade Organic Cotton",
    clothing_colour: "Black",
    clothing_brand: "Etiko",
    clothing_price: 9.95,
    external_link: "https://etiko.com.au/products/tshirt-unisex-wear-no-evil-2-organic-fairtrade",
    product_description: "Wear No Evil 2.0 Printed T-shirt, Unisex Black",
    item_image: "https://etiko.com.au/cdn/shop/products/ETIKO_FAIRTRADE_ORGANIC_COTTON_WEAR_NO_EVIL_PRINTED_UNISEX_TSHIRT_BLACK.jpg?v=1736981871&width=1946"
  }
]

etiko_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = etiko_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{etiko_products.length} Etiko products"

# Kotn Products
kotn_products = [
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 52.0,
    external_link: "https://kotn.com/products/mens-midweight-crew?colour=black",
    product_description: "Midweight Crew in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sMidweightCrew_Black2_3840x.progressive.jpg?v=1762269601"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 58.0,
    external_link: "https://kotn.com/products/mens-heavyweight-box-crew?colour=coffee-bean",
    product_description: "Heavyweight Box Crew in Coffee Bean",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sHeavyweightBoxCrew_CoffeeBean2_3840x.progressive.jpg?v=1759330141"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Green",
    clothing_brand: "Kotn",
    clothing_price: 58.0,
    external_link: "https://kotn.com/products/mens-midweight-longsleeve?colour=olive",
    product_description: "Midweight Longsleeve  in Olive",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sMidweightLongsleeve_Olive2_3840x.progressive.jpg?v=1760453264"
  },
  {
    clothing_item: "T-Shirt",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 38.0,
    external_link: "https://kotn.com/products/mens-rib-tank?colour=black",
    product_description: "Rib Tank in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sRibTank_Black2_074675f6-e4c6-4eb8-bbbc-6252c1b2c40c_3840x.progressive.jpg?v=1759442853"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Cotton",
    clothing_colour: "White",
    clothing_brand: "Kotn",
    clothing_price: 38.0,
    external_link: "https://kotn.com/products/men-essential-crew?colour=white",
    product_description: "Essential Crew in White",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sEssentialCrew_White2_24c1e325-ba26-4114-bd7e-78e43e5a95ad_3840x.progressive.jpg?v=1763568611"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 48.0,
    external_link: "https://kotn.com/products/mens-atlas-crew-longsleeve?colour=desert-beluga",
    product_description: "Atlas Crew Longsleeve in Desert/Beluga",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sAtlasWaffleLongsleeve_Beluga-Desert2_3840x.progressive.jpg?v=1761340182"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 52.0,
    external_link: "https://kotn.com/products/mens-rib-henley?colour=black",
    product_description: "Rib Henley in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sRibHenley_Black2_3840x.progressive.jpg?v=1761163676"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 28.0,
    external_link: "https://kotn.com/products/mens-atlas-crew?colour=black",
    product_description: "Atlas Crew in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sAtlasWaffleCrew_Black1_3840x.progressive.jpg?v=1762269524"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 78.0,
    external_link: "https://kotn.com/products/mens-box-slub-longsleeve?colour=desert",
    product_description: "Box Slub Longsleeve in Desert",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sBoxSlubLongsleeve_Desert2_3840x.progressive.jpg?v=1758133897"
  },
  {
    clothing_item: "Hoodie",
    clothing_material: "100% Organic Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 98.0,
    external_link: "https://kotn.com/products/tefnut-beach-hoodie?colour=otter",
    product_description: "Tefnut Beach Hoodie in Otter",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sTefnutBeachHoodie_Otter2_3840x.progressive.jpg?v=1759329644"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 122.0,
    external_link: "https://kotn.com/products/mens-denim-overshirt?colour=raw",
    product_description: "Denim Overshirt in Raw",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sDenimOvershirt_Raw2_3840x.progressive.jpg?v=1761339392"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "85% Cotton and 15% Recycled Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 162.0,
    external_link: "https://kotn.com/products/mens-denim-hooded-jacket?colour=rinse",
    product_description: "Denim Hooded Jacket in Rinse",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sDenimHoodedJacket_Rinse2_3840x.progressive.jpg?v=1759837104"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 218.0,
    external_link: "https://kotn.com/products/%20mens-malik-wool-jacket?colour=coffee-bean",
    product_description: "Malik Wool Jacket in Coffee Bean",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sMalikWoolJacket_CoffeeBean2_3840x.progressive.jpg?v=1760027393"
  },
  {
    clothing_item: "Jacket",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 242.0,
    external_link: "https://kotn.com/products/mens-A2-bomber-jacket?colour=washed-otter",
    product_description: "A-2 Bomber Jacket in Washed Otter",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sA-2Bomber_WashedOtter2_3840x.progressive.jpg?v=1758640971"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Natural",
    clothing_brand: "Kotn",
    clothing_price: 82.0,
    external_link: "https://kotn.com/products/womens-juniper-polo?colour=natural-dark-dusk",
    product_description: "Juniper Polo in Natural/Dark Dusk",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Women_sJuniperPolo_Natural-DarkDusk2_3840x.progressive.jpg?v=1762276305"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 78.0,
    external_link: "https://kotn.com/products/womens-philae-denim?colour=rinse",
    product_description: "Philae Denim in Rinse",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Women_sPhilaeDenim_Rinse4_2fc784a0-bb4d-4f2e-8aa2-70fa522394e4_3840x.progressive.jpg?v=1759446269"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Cotton",
    clothing_colour: "White",
    clothing_brand: "Kotn",
    clothing_price: 15.0,
    external_link: "https://kotn.com/products/unisex-crew-longsleeve?colour=white",
    product_description: "Unisex Crew Longsleeve in White",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/KSEssentialLongsleeve_White1_732fffb3-556e-40d0-9e97-b79ccb1f4ba8_3840x.progressive.jpg?v=1767817265"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Grey",
    clothing_brand: "Kotn",
    clothing_price: 12.0,
    external_link: "https://kotn.com/products/crew-socks?colour=grey-mix",
    product_description: "Crew Socks in Grey Mix",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/CREW-SOCKS_GREY-MIX_3840x.progressive.jpg?v=1762276184"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 148.0,
    external_link: "https://kotn.com/products/mens-nilus-trouser?colour=black",
    product_description: "Nilus Trouser in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/20260115_ECOMM_SS26_MEN_SNILUSTROUSER_BLACK_0449_3840x.progressive.jpg?v=1769118028"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Green",
    clothing_brand: "Kotn",
    clothing_price: 178.0,
    external_link: "https://kotn.com/products/mens-explorer-pant?colour=olive",
    product_description: "Explorer Pant in Olive",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sExplorerPant_Olive5_3840x.progressive.jpg?v=1756817726"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 138.0,
    external_link: "https://kotn.com/products/unisex-antifit-denim?colour=dark-wash",
    product_description: "Unisex Antifit Denim in Dark Wash",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/UnisexAntifitDenim_DarkWash1_174f2e04-bab8-435f-a9af-28348789493a_3840x.progressive.jpg?v=1762269195"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 148.0,
    external_link: "https://kotn.com/products/mens-rayan-denim?colour=black",
    product_description: "Rayan Denim in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sRayanDenim_Black1_42d395a3-be6c-40da-9dea-2e68cbbacc7a_3840x.progressive.jpg?v=1759332502"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "White",
    clothing_brand: "Kotn",
    clothing_price: 38.0,
    external_link: "https://kotn.com/products/mens-easy-crew?colour=white",
    product_description: "Easy Crew in White",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sEasyCrew_White2_f376a288-ebc5-49cc-bb94-148649ca217c_3840x.progressive.jpg?v=1764705010"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 158.0,
    external_link: "https://kotn.com/products/mens-sakkara-denim?colour=rinse",
    product_description: "Sakkara Denim in Rinse",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sSakkaraDenim_Rinse1_26587394-b232-407c-8ed7-4e04929d2e29_3840x.progressive.jpg?v=1761158189"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Cotton",
    clothing_colour: "Unknown",
    clothing_brand: "Kotn",
    clothing_price: 158.0,
    external_link: "https://kotn.com/products/mens-taba-denim?colour=mid-wash",
    product_description: "Taba Denim in Mid Wash",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sTabaDenim_MidWash1_3840x.progressive.jpg?v=1769540653"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Charcoal",
    clothing_brand: "Kotn",
    clothing_price: 122.0,
    external_link: "https://kotn.com/products/mens-wool-trouser?colour=584-charcoal",
    product_description: "Wool Trouser in 584 Charcoal",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Men_sWoolTrouser_Charcoal4_3840x.progressive.jpg?v=1760621646"
  },
  {
    clothing_item: "Jeans",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Natural",
    clothing_brand: "Kotn",
    clothing_price: 110.0,
    external_link: "https://kotn.com/products/unisex-antifit-denim-shorts?colour=natural",
    product_description: "Unisex Antifit Denim Shorts in Natural",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/UnisexAntifitDenimShorts_Natural1_3840x.progressive.jpg?v=1759442893"
  },
  {
    clothing_item: "Apparel",
    clothing_material: "100% Egyptian Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 158.0,
    external_link: "https://kotn.com/products/mens-ripstop-pant?colour=black",
    product_description: "Ripstop Pant in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/20260115_ECOMM_SS26_MEN_SRIPSTOPPANT_BLACK_0562_3840x.progressive.jpg?v=1769028384"
  },
  {
    clothing_item: "Pants",
    clothing_material: "100% Cotton",
    clothing_colour: "Black",
    clothing_brand: "Kotn",
    clothing_price: 98.0,
    external_link: "https://kotn.com/products/mens-essential-sweatpants?colour=black",
    product_description: "Essential Sweatpant in Black",
    item_image: "https://cdn.shopify.com/s/files/1/0932/1356/files/Mens_Essential_Sweatpant_Black_2483_3840x.progressive.jpg?v=1759446330"
  }
]

kotn_products.each do |attrs|
  ComparisonProduct.find_or_create_by!(external_link: attrs[:external_link]) do |p|
    p.brand = kotn_brand
    p.clothing_item = attrs[:clothing_item]
    p.clothing_material = attrs[:clothing_material]
    p.clothing_colour = attrs[:clothing_colour]
    p.clothing_brand = attrs[:clothing_brand]
    p.clothing_price = attrs[:clothing_price]
    p.product_description = attrs[:product_description]
    p.item_image = attrs[:item_image]
  end
end
puts "Created #{kotn_products.length} Kotn products"

puts "Seeding complete!"
puts "Total brands: #{Brand.count}"
puts "Total comparison products: #{ComparisonProduct.count}"
