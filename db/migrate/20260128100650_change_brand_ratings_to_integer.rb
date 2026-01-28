class ChangeBrandRatingsToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :brands, :planet_rating,  :integer, using: "planet_rating::integer"
    change_column :brands, :people_rating,  :integer, using: "people_rating::integer"
    change_column :brands, :animals_rating, :integer, using: "animals_rating::integer"
    change_column :brands, :overall_rating, :integer, using: "overall_rating::integer"
  end
end
