namespace :comparison_products do
  desc "Populate main_colour field based on clothing_colour analysis"
  task populate_main_colours: :environment do
    # Define color keyword mappings to main colors
    # Order matters - more specific matches should come first
    COLOR_MAPPINGS = {
      # Black variations
      "Black" => [
        "black", "nero", "ink", "jet", "onyx", "charcoal", "coal", "midnight",
        "phantom", "shadow", "night", "dark", "meteorite", "smoked", "soot"
      ],
      # White/Cream variations
      "White" => [
        "white", "ivory", "cream", "off-white", "offwhite", "porcelain",
        "pearl", "wool white", "natural", "vanilla", "pelican", "pumice",
        "bone", "chalk", "snow", "frost", "milk", "linen"
      ],
      # Grey variations
      "Grey" => [
        "grey", "gray", "silver", "ash", "fog", "heather", "marle", "melange",
        "stone", "graphite", "slate", "marge", "wing", "cloudy", "overcast",
        "cement", "concrete", "pewter", "steel", "titanium", "mineral"
      ],
      # Blue variations (removed ambiguous water words that could conflict with greens)
      "Blue" => [
        "navy", "indigo", "denim", "tidepool", "cobalt", "azure",
        "marine", "ocean", "aqua", "teal", "cyan", "clement", "wetland",
        "sunken", "selvedge", "rinse", "heritage", "medium score", "light score",
        "commercials", "rustic", "score", "wash it out", "vintage", "light vintage",
        "medium", "greenwich"
      ],
      # Green variations
      "Green" => [
        "green", "olive", "sage", "forest", "emerald", "moss",
        "oregano", "kambaba", "dusty green", "cold green", "cascade",
        "camo", "camouflage", "military", "army", "hunter", "fern", "mint",
        "pine", "eucalyptus", "jade", "lime", "chartreuse", "seaweed"
      ],
      # Brown/Tan variations
      "Brown" => [
        "brown", "tan", "khaki", "beige", "camel", "chestnut", "walnut",
        "russet", "bronze", "otter", "deer", "marlow", "beeswax", "chino",
        "nutmeg", "filbert", "tiger", "chore", "downtown", "twig",
        "sand", "sandy", "coffee", "mocha", "chocolate", "cocoa", "espresso",
        "cinnamon", "sienna", "umber", "sepia", "taupe", "mushroom", "maitake",
        "truffle", "almond", "hazelnut", "sherpa", "caramel", "toffee",
        "mahogany", "chestnut", "slab", "crunch"
      ],
      # Red variations
      "Red" => [
        "red", "crimson", "scarlet", "ruby", "oxblood", "burgundy", "wine",
        "maroon", "cherry", "sequoia", "roan", "cranberry", "garnet",
        "vermilion", "carmine", "cardinal", "brick", "rouge"
      ],
      # Pink variations
      "Pink" => [
        "pink", "rose", "blush", "coral", "salmon", "magenta", "fuchsia",
        "raspberry", "strawberry", "flamingo", "cerise", "hot pink"
      ],
      # Purple variations
      "Purple" => [
        "purple", "violet", "lavender", "plum", "grape", "permafrost purple",
        "mauve", "lilac", "amethyst", "orchid", "eggplant", "aubergine",
        "mulberry", "wine", "magenta"
      ],
      # Yellow/Gold variations
      "Yellow" => [
        "yellow", "gold", "mustard", "amber", "honey", "lemon", "harvest",
        "talon", "sun", "beeswax", "icarus", "canary", "butter", "straw",
        "blonde", "flax", "maize", "saffron", "dandelion", "sunny"
      ],
      # Orange variations
      "Orange" => [
        "orange", "tangerine", "peach", "apricot", "rust", "terracotta",
        "peel", "copper", "burnt", "marmalade", "papaya", "mango",
        "persimmon", "pumpkin", "ginger"
      ]
    }

    # Specific full-name mappings for creative names that don't contain color keywords
    SPECIFIC_MAPPINGS = {
      # Denim-related (blue)
      "dry" => "Blue",
      "raw denim" => "Blue",
      "greatest story selvedge" => "Blue",
      "new selvedge rinse" => "Blue",
      "my honor no dx" => "Blue",
      "rebel edge" => "Blue",
      "style tension distressed" => "Blue",
      "solucell western" => "Blue",
      "twist and sew" => "Blue",
      "lost in translation" => "Blue",
      "rewrite hope" => "Blue",
      "office refresh" => "Blue",
      "analyze this ltw" => "Blue",
      "next one down" => "Blue",
      "until its dust" => "Blue",
      "thats the answer" => "Blue",
      "where we going" => "Blue",
      "wherever you are" => "Blue",
      "darted denim" => "Blue",
      "denim de jour" => "Blue",
      "off roading stf str" => "Blue",
      "lift up" => "Blue",
      "hold my bag" => "Blue",
      "up and away" => "Blue",
      "max volume" => "Blue",
      "my pockets full" => "Blue",
      "my tinted journey" => "Blue",
      "dance around" => "Blue",
      "clean run" => "Blue",
      "3pm in soma" => "Blue",
      "all i can do" => "Blue",
      "always the optimist" => "Blue",
      "automatic rizz" => "Blue",
      "bite back wb" => "Blue",
      "easy days" => "Blue",
      "light workout" => "Blue",
      "mello mornings" => "Blue",
      "on the town" => "Blue",
      "play a tune" => "Blue",
      # Plaid/stripe patterns - typically mixed, default to primary base
      "aldo plaid allure twill" => "Blue",
      "marris stripe" => "Blue",
      # Place names that contain color words
      "greenwich denim" => "Blue",
      # Water/nature themed names (typically blue)
      "lake side cool" => "Blue",
      "river bank cool" => "Blue",
      # Brown/tan specific
      "built to last sherpa" => "Brown",
      "bandana maitake" => "Brown",
      # Unknown/multicolor
      "ombre camo soft camo" => "Green",
      "shrouded in mystery" => "Black",
      "dip dry" => "Blue",
      "unknown" => "Unknown",
      "s" => "Unknown"
    }

    # Primary color words that should take precedence
    PRIMARY_COLORS = {
      "green" => "Green",
      "blue" => "Blue",
      "red" => "Red",
      "pink" => "Pink",
      "purple" => "Purple",
      "yellow" => "Yellow",
      "orange" => "Orange",
      "black" => "Black",
      "white" => "White",
      "grey" => "Grey",
      "gray" => "Grey",
      "brown" => "Brown"
    }

    def determine_main_colour(colour_name)
      return "Unknown" if colour_name.blank?

      colour_lower = colour_name.downcase.strip

      # First check specific full-name mappings
      return SPECIFIC_MAPPINGS[colour_lower] if SPECIFIC_MAPPINGS.key?(colour_lower)

      # Check for explicit primary color words first (e.g., "Basin Green" should be Green)
      PRIMARY_COLORS.each do |color_word, main_colour|
        return main_colour if colour_lower.include?(color_word)
      end

      # Then check each main color's keywords for more nuanced matches
      COLOR_MAPPINGS.each do |main_colour, keywords|
        keywords.each do |keyword|
          return main_colour if colour_lower.include?(keyword)
        end
      end

      # Default to Unknown if no match found
      "Unknown"
    end

    puts "Starting main_colour population for ComparisonProducts..."
    puts "Total products: #{ComparisonProduct.count}"

    updated_count = 0
    unknown_colours = []

    ComparisonProduct.find_each do |product|
      main_colour = determine_main_colour(product.clothing_colour)
      product.update_column(:main_colour, main_colour)
      updated_count += 1

      if main_colour == "Unknown" && product.clothing_colour.present?
        unknown_colours << product.clothing_colour
      end

      print "." if updated_count % 10 == 0
    end

    puts "\n\nCompleted! Updated #{updated_count} products."

    # Report distribution
    puts "\nColour distribution:"
    ComparisonProduct.group(:main_colour).count.sort_by { |_, v| -v }.each do |colour, count|
      puts "  #{colour}: #{count}"
    end

    if unknown_colours.any?
      puts "\nColours mapped to 'Unknown' (may need manual review):"
      unknown_colours.uniq.sort.each { |c| puts "  - #{c}" }
    end
  end
end
