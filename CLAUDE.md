# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ecomatch is a Rails 7.1 sustainable fashion alternative finder. Users upload clothing images or provide links, GPT-4o analyzes the item asynchronously via background jobs, and the app matches it against eco-friendly alternatives from sustainable brands.

## Common Commands

```bash
# Development
rails server                    # Start server on localhost:3000
rails console                   # Rails console
bin/jobs                        # Start Solid Queue worker for background jobs

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
├── controllers/      # 7 main controllers
├── helpers/          # Application helpers
├── javascript/       # Stimulus controllers, entrypoints
├── jobs/             # Background jobs (SearchAnalysisJob via Solid Queue)
├── mailers/          # Email templates
├── models/           # 7 core models
└── views/            # ERB templates organized by controller

config/
├── initializers/     # Devise, Ruby LLM, ScrapingBee, Solid Queue configs
├── environments/     # Development/Production/Test configs
└── routes.rb         # Nested resource routing

db/
├── migrate/          # 16 migrations
├── seeds.rb          # Seed data for brands (50+ brands)
└── schema.rb         # PostgreSQL schema

lib/
├── scrapers/         # 9 brand scrapers (Patagonia, Kotn, ASKET, etc.)
├── scraping_bee_api.rb  # ScrapingBee service wrapper
└── tasks/            # Rake tasks

test/
├── models/           # Model tests
├── controllers/      # Controller tests
└── fixtures/         # Test data files
```

## Architecture

**Core Flow:**
1. User uploads image OR provides clothing link → `SearchesController#create`
2. Search record created with status `"processing"` → redirect to processing page
3. `SearchAnalysisJob` runs asynchronously via Solid Queue
4. AI (GPT-4o via ruby_llm gem) analyzes clothing, extracts: item type, material, colour, brand, price
5. Job broadcasts completion via Turbo Stream → user redirected to matches
6. Results matched against `comparison_products` table via AI similarity analysis
7. Users save favorites to wishlists (linked to ComparisonProduct)

## Models

### User (Devise)
- **Relationships:** `has_many :searches, dependent: :destroy`, `has_many :wishlist_items, dependent: :destroy`, `has_many :matches, through: :searches`
- **Devise modules:** `database_authenticatable`, `registerable`, `recoverable`, `rememberable`, `validatable`

### Search
- **Relationships:** `belongs_to :user`, `has_many :matches, dependent: :destroy`, `has_one_attached :uploaded_image`
- **Validation:** `image_or_link_present` - must have image OR link, not both
- **Key attributes:** `uploaded_image`, `uploaded_link`, `system_prompt`, `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `clothing_price`, `item_image`, `item_name`, `item_description`, `status`
- **Status values:** `"pending"` (default), `"processing"`, `"completed"`, `"failed"`

### Match
- **Relationships:** `belongs_to :search`, `belongs_to :comparison_product`
- **Delegation:** `delegate :user, to: :search`
- **Validation:** `similarities` presence required

### ComparisonProduct
- **Relationships:** `belongs_to :brand`, `has_many :wishlist_items, dependent: :destroy`
- **Required fields:** `brand_id`, `clothing_item`, `clothing_material`, `clothing_colour`, `clothing_brand`, `external_link`, `product_description`
- **Key attributes:** `item_image`, `clothing_price`, `main_colour`
- **Scopes:** `by_clothing_item`, `by_clothing_colour`, `by_clothing_material`, `by_overall_rating`, `ordered_by_params`
- **Class methods:** `unique_clothing_items`, `valid_clothing_items` (9 types: t-shirt, hoodie, jacket, jeans, leggings, pants, shorts, sweater, shirt)

### Brand
- **Relationships:** `has_many :comparison_products`
- **Required fields:** `name`, `planet_rating`, `people_rating`, `animals_rating`, `overall_rating`, `description`
- **Optional fields:** `logo` (URL string)
- **Ratings:** Integer values (1-5 scale) for sustainability scoring
- **Index:** `index_brands_on_lower_name` for case-insensitive lookups

### WishlistItem
- **Relationships:** `belongs_to :user`, `belongs_to :comparison_product`
- **Unique constraint:** `user_id` scoped to `comparison_product_id` (prevents duplicate saves)

## Controllers

### SearchesController
- **Actions:** `index`, `new`, `create`, `processing`, `show`, `edit`, `update`
- **Key logic in `create`:**
  - Validates image OR link (not both)
  - Creates search with status `"processing"`
  - Enqueues `SearchAnalysisJob` for async processing
  - Redirects to `processing` action (shows loading UI)
- **Processing action:** Shows brand logo carousel while job runs
- **Authentication:** `before_action :authenticate_user!`

### MatchesController
- **Actions:** `index`, `show`, `show_product` (member)
- **Before actions:** `set_search`
- **Eager loads:** brand data for performance
- **Features:** Filter dropdowns for item type, colour, material, overall rating

### ExploreController
- **Actions:** `index`, `show`
- **Purpose:** Browse all comparison products independently of searches
- **Features:** Same filtering as MatchesController
- **Authentication:** `before_action :authenticate_user!`

### WishlistItemsController
- **Actions:** `create`, `destroy`
- **Before actions:** `authenticate_user!`, `set_comparison_product`
- **Responses:** Turbo Stream for AJAX updates
- **Handles:** Duplicate prevention via model validation

### WishlistsController
- **Actions:** `index`
- **Displays:** User's saved wishlist items with eager-loaded associations

### PagesController
- **Actions:** `home`, `about`, `contact`
- **Home:** Loads top 7 brands by overall_rating for display

## Background Jobs

### SearchAnalysisJob
- **Queue:** `:default` (via Solid Queue)
- **Purpose:** Async AI analysis of uploaded images or links
- **Methods:**
  - `analyze_image(search)` - Uses RubyLLM for GPT-4o vision analysis
  - `analyze_link(search)` - Uses ScrapingBeeApi + GPT-4o
  - `normalize_colour(colour)` - Maps 30+ color variants to 12 standard colors
  - `broadcast_completion(search)` - Turbo Stream broadcast on success
  - `broadcast_error(search, error)` - Turbo Stream broadcast on failure
- **Color normalization:** Maps shades (e.g., "navy", "teal", "forest") to base colors (blue, green)

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
├── status (string, default: "pending")
└── timestamps

brands
├── name (string)
├── planet_rating (integer, 1-5)
├── people_rating (integer, 1-5)
├── animals_rating (integer, 1-5)
├── overall_rating (integer, 1-5)
├── description (text)
├── logo (string, URL)
├── index on lower(name)
└── timestamps

comparison_products
├── brand_id (FK → brands, indexed)
├── clothing_item/material/colour/brand
├── main_colour (string)
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
├── comparison_product_id (FK → comparison_products, indexed)
├── unique index on (user_id, comparison_product_id)
└── timestamps

solid_queue_* tables (job queue infrastructure)

active_storage_blobs/attachments (for Cloudinary image uploads)
```

## Routes

```ruby
devise_for :users                          # Devise authentication routes
root to: "pages#home"                      # GET /
get "about", to: "pages#about"             # GET /about
get "contact", to: "pages#contact"         # GET /contact

resources :explore, only: [:index, :show]  # Browse all products

resources :searches, only: [:new, :create, :edit, :update, :show] do
  member do
    get :processing                        # GET /searches/:id/processing
  end
  resources :matches, only: [:index, :show] do
    member do
      get :show_product                    # GET /searches/:search_id/matches/:id/products/:id
    end
  end
end

resources :comparison_products, only: [] do
  member do
    post :add_to_wishlist                  # POST /comparison_products/:id/add_to_wishlist
    delete :remove_from_wishlist           # DELETE /comparison_products/:id/remove_from_wishlist
  end
end

resources :users, only: [:show, :edit, :update] do
  resources :wishlist_items, only: [:index, :show, :destroy]
  get 'wishlist', to: 'wishlists#index'    # GET /users/:id/wishlist
  get 'searches', to: 'searches#index'     # GET /users/:id/searches
end

get "up" => "rails/health#show"            # Health check
```

## Views

### Layouts
- `layouts/application.html.erb` - Main layout with navbar, footer, yield
- `layouts/mailer.html.erb` - Email template

### Pages
- `pages/home.html.erb` - Hero banner, search form, top brands display
- `pages/about.html.erb` - About page
- `pages/contact.html.erb` - Contact page
- `searches/new.html.erb` - Search form with image/link toggle, form-loader overlay
- `searches/processing.html.erb` - Loading page with brand logo carousel (Turbo Stream updates)
- `matches/index.html.erb` - Match results with filter dropdowns, match cards grid
- `matches/show.html.erb` - Product detail with brand sustainability ratings
- `explore/index.html.erb` - Browse all products with filters
- `wishlists/index.html.erb` - User's saved matches grid

### Shared Partials
- `shared/_navbar.html.erb` - Navigation (logo, conditional login/dropdown)
- `shared/_footer.html.erb` - Footer
- `shared/_match_card.html.erb` - Reusable product card with wishlist heart button

## JavaScript/Stimulus

**Entry point:** `app/javascript/entrypoints/application.js`

**Dependencies:**
- `turbo-rails` (Hotwire page acceleration)
- `stimulus` (modest JS framework)
- `bootstrap` + `@popperjs/core`

**Stimulus Controllers:**

1. **form_loader_controller.js**
   - Targets: `form`, `overlay`
   - Shows loading overlay for minimum 1000ms, then submits form
   - Intercepts form submit event

2. **filter_form_controller.js**
   - Targets: `form`
   - Auto-submits filter form on dropdown change
   - Debounces text input (400ms delay)
   - Methods: `submit()` (immediate), `debounceSubmit()` (delayed)

3. **brand_carousel_controller.js**
   - Targets: `logo`, `brandName`, `logoContainer`
   - Values: `searchId`, `brands` (array), `interval` (default: 700ms)
   - Rotates through brand logos during search processing
   - Methods: `startCarousel()`, `stopCarousel()`, `nextBrand()`

4. **hello_controller.js** - Placeholder

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

**Usage Pattern (SearchAnalysisJob):**
```ruby
# Image analysis
chat = RubyLLM.chat(model: "gpt-4o").with_instructions(search.system_prompt)
response = chat.ask("Analyze this clothing item", with: { image: search.uploaded_image.url })

# Link analysis (after ScrapingBee fetch)
prompt = build_link_analysis_prompt(scraped_data)
response = chat.ask(prompt)

# Parse JSON response
json_content = response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
parsed = JSON.parse(json_content)
```

## Services & Utilities

### ScrapingBeeApi (`lib/scraping_bee_api.rb`)
- HTTP GET to ScrapingBee endpoint
- Features: JS rendering, stealth proxy, CSS selector extraction
- Extracts: Open Graph meta tags (og:title, og:description, og:image) + page title
- Returns JSON with: `item_name`, `item_description`, `item_image`, `page_title`

### ApplicationHelper
- `saved_to_wishlist?(comparison_product)` - Check if user saved product
- `wishlist_item_for(comparison_product)` - Get wishlist item record
- `brand_logo(brand_name)` - Map brand name to logo filename

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
- Optional Cloudinary image upload

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

# Background Jobs
solid_queue                # Database-backed job queue

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
  - **High rated:** Patagonia (5), Everlane (5), Reformation (5)
  - **Medium rated:** H&M (3), Zara (3), Uniqlo (4)
  - **Low rated:** SHEIN (1), TEMU (1), Fashion Nova (1)

## Key Workflows

### Search Flow (Async)
1. User uploads image OR pastes product link (validated: must be one or other)
2. `SearchesController#create`:
   - Creates search record with status `"processing"`
   - Enqueues `SearchAnalysisJob.perform_later(search.id)`
   - Redirects to `processing_search_path(search)`
3. Processing page shows brand logo carousel via `brand_carousel_controller`
4. `SearchAnalysisJob` performs analysis:
   - Image: RubyLLM/GPT-4o vision analysis
   - Link: ScrapingBeeApi fetch → GPT-4o analysis
   - Updates search with extracted data, normalizes colour
   - Sets status to `"completed"` or `"failed"`
   - Broadcasts via Turbo Stream
5. Client receives broadcast → redirects to `search_matches_path`

### Match Display
1. `MatchesController#index` fetches matches with eager-loaded brand data
2. Filter dropdowns for: item type, colour, material, overall rating
3. `filter_form_controller` auto-submits on change with debouncing
4. Match cards with: product image, brand name, sustainability rating, price
5. Wishlist heart button (Turbo Stream updates)

### Explore Products
1. `ExploreController#index` shows all comparison products
2. Same filtering as matches (item, colour, material, rating)
3. Independent of search - users can browse catalog directly

### Wishlist Management
- Save: `POST /comparison_products/:id/add_to_wishlist`
- Unsave: `DELETE /comparison_products/:id/remove_from_wishlist`
- Turbo Stream responses for instant UI updates
- Duplicate prevention via unique constraint (user_id, comparison_product_id)
- View all: `GET /users/:id/wishlist`

## Deployment Notes

**Puma Configuration:**
- Default: 5 threads min/max
- Port: 3000 (or ENV PORT)
- Worker timeout: 3600s in development

**Solid Queue:**
- Database-backed job queue (no Redis required)
- Run worker: `bin/jobs`
- Tables: `solid_queue_*` in PostgreSQL

**Active Storage:**
- Cloudinary service for image storage
- Image processing with ImageMagick

**Security:**
- Devise with bcrypt hashing
- CSRF protection via `csrf_meta_tags`
- Content Security Policy headers configured
