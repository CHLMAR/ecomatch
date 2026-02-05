class PagesController < ApplicationController
  def home
    @top_brands = Brand.where.not(logo: [nil, ""])
                       .order(Arel.sql("(planet_rating + people_rating + animals_rating) / 3.0 DESC"))
                       .limit(7)
  end

  def about
  end

  def contact
  end
end
