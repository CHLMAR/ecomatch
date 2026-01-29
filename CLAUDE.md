# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ecomatch is a Rails 7.1 sustainable fashion alternative finder. Users upload clothing images or provide links, GPT-4o analyzes the item, and the app matches it against eco-friendly alternatives from sustainable brands.

## Common Commands

```bash
# Development
rails server                    # Start server on localhost:3000
rails console                   # Rails console

# Database
rails db:setup                  # Create, migrate, and seed (creates test user: eco@match.com/test123)
rails db:migrate                # Run pending migrations
rails db:seed                   # Load seed data

# Testing
rails test                      # Run all tests
rails test test/models/user_test.rb              # Run single test file
rails test test/models/user_test.rb:10           # Run specific test at line

# Linting
rubocop                         # Lint Ruby code
rubocop -A                      # Auto-fix issues

# Custom rake tasks
rails patagonia:scrape DEMO=true QUERY=jacket LIMIT=10    # Scrape Patagonia products
rails patagonia:list                                       # List Patagonia comparison products
```

## Architecture

**Core Flow:**
1. User uploads image OR provides clothing link → `SearchesController#create`
2. AI (GPT-4o via ruby_llm gem) analyzes clothing, extracts: item type, material, colour, brand, price
3. Results matched against `comparison_products` table via AI similarity analysis
4. Matches displayed with sustainable brand alternatives
5. Users save favorites to wishlists

**Key Models:**
- `User` → has_many `Search` → has_many `Match` → belongs_to `ComparisonProduct` → belongs_to `Brand`
- `WishlistItem` links User to saved Matches (unique constraint prevents duplicates)
- `Search` has_one_attached `uploaded_image` (Active Storage with Cloudinary)

**AI Integration Pattern:**
```ruby
# SearchesController builds prompts dynamically
# JSON parsing uses safe pattern: JSON.parse(response) rescue nil
# Config in config/initializers/ruby_llm.rb
# Uses GITHUB_TOKEN env var for Azure/GitHub Models endpoint
```

**Routing:**
- Nested: `searches/:search_id/matches`
- Wishlist save: `POST searches/:search_id/matches/:id/save`
- User wishlists: `users/:user_id/wishlist`

## Environment Variables

Required in `.env`:
- `GITHUB_TOKEN` - For GPT-4o via Azure Models
- Cloudinary credentials for image storage:
  - `CLOUDINARY_URL` - Format: `cloudinary://api_key:api_secret@cloud_name`
  - OR individual vars: `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`

## Web Scraping - Patagonia Scraper

Location: `lib/scrapers/patagonia_scraper.rb`

Uses Playwright browser automation to bypass anti-bot protection and extract real materials & hi-res images.

### Setup (One-Time)

```bash
bundle install                      # Installs playwright-ruby-client gem
npm install @playwright/test        # Playwright npm package
npx playwright install chromium     # Browser binary
```

### Running the Scraper

```bash
# Scrape and save to database (default)
ruby lib/scrapers/patagonia_scraper.rb t-shirt 10 --visible

# Scrape without saving (just output JSON)
ruby lib/scrapers/patagonia_scraper.rb jacket 5 --visible --no-save
```

**Note:** `--visible` flag is required - headless mode is blocked by Patagonia.

### Output Fields

| Field | Example |
|-------|---------|
| `product_description` | Men's P-6 Logo Responsibili-Tee® |
| `clothing_item` | T-Shirt |
| `clothing_material` | 5.5-oz 50% recycled cotton/50% postconsumer recycled polyester jersey |
| `clothing_colour` | Talon Gold |
| `clothing_brand` | Patagonia |
| `clothing_price` | 45.0 |
| `item_image` | `https://www.patagonia.com/dw/image/v2/.../hi-res/38504_TNGO.jpg` |
| `external_link` | `https://www.patagonia.com/product/mens-p-6-logo-responsibili-tee/38504.html` |

### Programmatic Usage (Rails console)

```ruby
require_relative 'lib/scrapers/patagonia_scraper'
products = PatagoniaPlaywrightScraper.scrape("t-shirt", limit: 10, headless: false)
# Products are returned as array of hashes - save manually if needed
```

### Troubleshooting

**"Hang Tight! Routing to checkout..." page:**
- Patagonia detected headless browser → use `--visible` flag

**Image URLs don't display:**
- Scraper extracts hi-res URLs from `<picture><source>` elements with proper CDN hash

## Testing

- Framework: Rails TestUnit with fixtures in `/test/fixtures`
- System tests: Capybara with Selenium WebDriver
- Parallel execution configured
