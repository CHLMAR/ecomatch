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

## Project Structure

```
app/
├── assets/           # Images, stylesheets (SCSS), manifests
├── channels/         # Action Cable for real-time features
├── controllers/      # 6 main controllers
├── helpers/          # Application helpers
├── javascript/       # Stimulus controllers, importmap config
├── jobs/             # Background jobs (Active Job)
├── mailers/          # Email templates
├── models/           # 8 core models
└── views/            # ERB templates organized by controller

config/
├── initializers/     # Devise, Ruby LLM, ScrapingBee configs
├── environments/     # Development/Production/Test configs
└── routes.rb         # Nested resource routing

db/
├── migrate/          # 10 migrations
├── seeds.rb          # Seed data for brands (50+ brands)
└── schema.rb         # PostgreSQL schema

lib/
├── scrapers/         # 9 brand scrapers (Patagonia, Kotn, ASKET, etc.)
└── tasks/            # Rake tasks

test/
├── models/           # Model tests
├── controllers/      # Controller tests
└── fixtures/         # Test data files
```

## Architecture

**Core Flow:**
1. User uploads image OR provides clothing link → `SearchesController#create`
2. AI (GPT-4o via ruby_llm gem) analyzes clothing, extracts: item type, material, colour, brand, price
3. Results matched against `comparison_products` table via AI similarity analysis
4. Matches displayed with sustainable brand alternatives
5. Users save favorites to wishlists

## Models

### User (Devise)
- **Relationships:** `has_many :searches`, `has_many :wishlist_items`, `has_many :matches through: :searches`
- **Devise modules:** `database_authenticatable`, `registerable`, `recoverable`, `rememberable`, `validatable`

### Search
- **Relationships:** `belongs_to :user`, `has_many :matches dependent: :destroy`, `has_one_attached :uploaded_image`
- **Validation:** `image_or_link_present` - must have image OR link, not both
- **Key attributes:** `uploaded_image`, `uploaded_link`, `system_prompt`, `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `clothing_price`, `item_image`, `item_name`, `item_description`

### Match
- **Relationships:** `belongs_to :search`, `belongs_to :comparison_product`
- **Delegation:** `delegate :user to: :search`
- **Validation:** `similarities` presence required

### ComparisonProduct
- **Relationships:** `belongs_to :brand`
- **Required fields:** `brand_id`, `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `external_link`, `product_description`
- **Key attributes:** Product details scraped from sustainable brand websites

### Brand
- **Relationships:** `has_many :comparison_products`
- **Required fields:** `name`, `planet_rating`, `people_rating`, `animals_rating`, `overall_rating`, `description`
- **Ratings:** Integer values (1-5 scale) for sustainability scoring

### WishlistItem
- **Relationships:** `belongs_to :user`, `belongs_to :match`, `belongs_to :comparison_product`
- **Unique constraint:** `user_id` scoped to `match_id` (prevents duplicate saves)

## Controllers

### SearchesController
- **Actions:** `new`, `create`, `edit`, `update`, `show`
- **Key logic in `create`:**
  - Validates image OR link (not both)
  - If image: Uses RubyLLM (GPT-4o) for image analysis
  - If link: Uses ScrapingBeeApi for link scraping
  - Parses JSON response and updates search record
- **Authentication:** `before_action :authenticate_user!`

### MatchesController
- **Actions:** `index`, `show`
- **Eager loads:** brand data for performance
- **Features:** Filter dropdowns for color, material, clothing item

### WishlistItemsController
- **Actions:** `create` (save), `destroy` (unsave)
- **Routes:** `POST save`, `DELETE unsave` as member routes
- **Handles:** Duplicate prevention via model validation

### WishlistsController
- **Actions:** `index`
- **Displays:** User's saved wishlist items with eager-loaded associations

### PagesController
- **Actions:** `home` (root path)

## Database Schema

```
users (Devise)
├── email (unique, indexed)
├── encrypted_password
├── reset_password_token (indexed)
├── remember_created_at
└── timestamps

searches
├── user_id (FK → users, indexed)
├── uploaded_link (string)
├── system_prompt (string)
├── clothing_item/material/colour/brand/price
├── item_image/name/description
└── timestamps

brands
├── name (string)
├── planet_rating (integer, 1-5)
├── people_rating (integer, 1-5)
├── animals_rating (integer, 1-5)
├── overall_rating (integer, 1-5)
├── description (text)
└── timestamps

comparison_products
├── brand_id (FK → brands, indexed)
├── clothing_item/material/colour/brand
├── clothing_price (float)
├── external_link (string)
├── product_description (text)
├── item_image (string)
└── timestamps

matches
├── search_id (FK → searches, indexed)
├── comparison_product_id (FK → comparison_products, indexed)
├── similarities (text)
└── timestamps

wishlist_items
├── user_id (FK → users, indexed)
├── match_id (FK → matches, indexed)
├── comparison_product_id (FK → comparison_products, indexed)
├── unique index on (user_id, match_id)
└── timestamps

active_storage_blobs/attachments (for Cloudinary image uploads)
```

## Routes

```ruby
devise_for :users                          # Devise authentication routes
root to: "pages#home"                      # GET /

resources :searches, only: [:new, :create, :edit, :update, :show] do
  resources :matches, only: [:index, :show] do
    member do
      post 'save', to: 'wishlist_items#create'      # POST /searches/:search_id/matches/:id/save
      delete 'unsave', to: 'wishlist_items#destroy' # DELETE /searches/:search_id/matches/:id/unsave
    end
  end
end

resources :users, only: [:show, :edit, :update] do
  resources :wishlist_items, only: [:index, :show, :destroy]
  get 'wishlist', to: 'wishlists#index'    # GET /users/:id/wishlist
end

get "up" => "rails/health#show"            # Health check
```

## Views

### Layouts
- `layouts/application.html.erb` - Main layout with navbar, footer, yield
- `layouts/mailer.html.erb` - Email template

### Pages
- `pages/home.html.erb` - Hero banner, search form (conditional for logged-in users)
- `searches/new.html.erb` - Search form with image/link toggle, form-loader overlay
- `matches/index.html.erb` - Match results with filter dropdowns, match cards grid
- `matches/show.html.erb` - Product detail with brand sustainability ratings, similar products carousel
- `wishlists/index.html.erb` - User's saved matches grid

### Shared Partials
- `shared/_navbar.html.erb` - Navigation (logo, conditional login/dropdown)
- `shared/_footer.html.erb` - Footer
- `shared/_match_card.html.erb` - Reusable product card with wishlist heart button

## JavaScript/Stimulus

**Importmap dependencies:**
- `turbo-rails` (Hotwire page acceleration)
- `stimulus` (modest JS framework)
- `bootstrap` + `@popperjs/core`

**Stimulus Controllers:**

1. **form_loader_controller.js** (`app/javascript/controllers/`)
   - Targets: `form`, `overlay`
   - Shows loading overlay for 6000ms minimum, then submits form
   - Message: "Entering the realm of sustainable fashion..."

2. **hello_controller.js** - Placeholder

## Stylesheets (SCSS)

```
app/assets/stylesheets/
├── application.scss          # Main import file
├── config/
│   ├── _bootstrap_variables.scss
│   ├── _colors.scss         # Color palette
│   └── _fonts.scss
├── components/
│   ├── _alert.scss
│   ├── _avatar.scss
│   ├── _footer.scss
│   ├── _loader.scss         # Form-loader animation
│   ├── _match_card.scss     # Product card styling
│   └── _navbar.scss
└── pages/
    ├── _home.scss           # Hero banner, search form
    └── _matches.scss        # Results layout, filters
```

**Framework:** Bootstrap 5.3 + Font Awesome 6.1 (via CDN) + custom SCSS

## AI Integration

**Configuration:** `config/initializers/ruby_llm.rb`
```ruby
RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("GITHUB_TOKEN")
  config.openai_api_base = "https://models.inference.ai.azure.com"
  config.default_model = "gpt-4o"
end
```

**Usage Pattern (SearchesController#create):**
```ruby
@chat = RubyLLM.chat(model: "gpt-4o").with_instructions(@search.system_prompt)
@response = @chat.ask("Analyze this clothing item", with: { image: @search.uploaded_image.url })
json_content = @response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
parsed = JSON.parse(json_content) rescue nil
```

## Services & Utilities

### ScrapingBeeApi (`lib/scraping_bee_api.rb`)
- HTTP GET to ScrapingBee endpoint
- Features: JS rendering, premium proxy, AI query
- Returns JSON with: `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `clothing_price`, `item_image`, `item_name`, `item_description`

## Web Scraping

### Available Scrapers (`lib/scrapers/`)

| Scraper | Brand | Notes |
|---------|-------|-------|
| `patagonia_scraper.rb` | Patagonia | Two-step (search → detail), material extraction |
| `kotn_scraper.rb` | Kotn | Shopify store, collection-based |
| `asket_scraper.rb` | ASKET | Swedish sustainable brand |
| `etiko_scraper.rb` | Etiko | Ethical fashion brand |
| `levis_scraper.rb` | Levi's | Denim focus |
| `lululemon_scraper.rb` | Lululemon | Athletic wear |
| `mudjeans_scraper.rb` | MUD Jeans | Sustainable denim |
| `luisaviaroma_scraper.rb` | LuisaViaRoma | Luxury sustainable |
| `good_on_you_scraper.rb` | Good On You | Rating aggregator |

### Common Scraper Pattern
- Playwright with anti-detection: `--disable-blink-features=AutomationControlled`
- Realistic user agent, page delays (2-2.5s load, 1.5s between products)
- Database saving with duplicate checking (external_link uniqueness)
- `--visible` flag often required to bypass anti-bot detection

### Patagonia Scraper Details

```bash
# Scrape and save to database
ruby lib/scrapers/patagonia_scraper.rb t-shirt 10 --visible

# Scrape without saving
ruby lib/scrapers/patagonia_scraper.rb jacket 5 --visible --no-save
```

**Output Fields:**
| Field | Example |
|-------|---------|
| `product_description` | Men's P-6 Logo Responsibili-Tee |
| `clothing_item` | T-Shirt |
| `clothing_material` | 50% recycled cotton/50% postconsumer recycled polyester |
| `clothing_colour` | Talon Gold |
| `clothing_price` | 45.0 |
| `item_image` | Hi-res CDN URL |
| `external_link` | Product page URL |

### Playwright Setup (One-Time)

```bash
bundle install                      # Installs playwright-ruby-client gem
npm install @playwright/test        # Playwright npm package
npx playwright install chromium     # Browser binary
```

## Environment Variables

Required in `.env`:
```
GITHUB_TOKEN              # Azure Models API key for GPT-4o
SCRAPINGBEE_API_KEY       # ScrapingBee API key for link analysis
CLOUDINARY_URL            # cloudinary://key:secret@cloud_name
```

## Key Gems

```ruby
# Core
rails ~> 7.1.6
pg ~> 1.1                  # PostgreSQL

# Frontend
bootstrap ~> 5.3
stimulus-rails, turbo-rails
simple_form
font-awesome-sass ~> 6.1

# Authentication
devise

# AI/LLM
ruby_llm                   # GPT-4o integration

# Images
cloudinary
image_processing ~> 1.2

# Scraping
playwright-ruby-client     # (development/test only)

# Search
pg_search
```

## Testing

- **Framework:** Rails TestUnit with fixtures in `/test/fixtures`
- **System tests:** Capybara with Selenium WebDriver
- **Parallel execution:** Configured in `test_helper.rb`
- **Test user:** `eco@match.com` / `test123` (from seeds)

## Seed Data

`db/seeds.rb` includes:
- Test user: `eco@match.com` / `test123`
- 50+ brands with sustainability ratings (1-5 scale):
  - **High rated:** Patagonia (4.5), Everlane (4.5), Reformation (4.5)
  - **Medium rated:** H&M (3), Zara (3), Uniqlo (4)
  - **Low rated:** SHEIN (1), TEMU (1), Fashion Nova (1)

## Key Workflows

### Search Flow
1. User uploads image OR pastes product link (validated: must be one or other)
2. `SearchesController#create`:
   - Image: RubyLLM/GPT-4o analyzes → JSON extraction
   - Link: ScrapingBeeApi fetches → AI query → JSON extraction
3. Search record updated with: `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `clothing_price`, `item_image`, `item_name`, `item_description`
4. Redirect to `search_matches_path` → displays Match results

### Match Display
1. `MatchesController#index` fetches matches with eager-loaded brand data
2. Filter dropdowns for: color, material, clothing item
3. Match cards with: product image, brand name, sustainability rating, price
4. Wishlist heart button (conditional on authentication)

### Wishlist Management
- Save: `POST /searches/:search_id/matches/:id/save`
- Unsave: `DELETE /searches/:search_id/matches/:id/unsave`
- Duplicate prevention via unique constraint
- View all: `GET /users/:id/wishlist`

## Deployment Notes

**Puma Configuration:**
- Default: 5 threads min/max
- Port: 3000 (or ENV PORT)
- Worker timeout: 3600s in development

**Active Storage:**
- Cloudinary service for image storage
- Image processing with ImageMagick

**Security:**
- Devise with bcrypt hashing
- CSRF protection via `csrf_meta_tags`
- Content Security Policy headers configured
