class PagesController < ApplicationController
  def home
    @top_brands = Brand.order(overall_rating: :desc).limit(7)
  end

  def about
  end

  def contact
  end
end
