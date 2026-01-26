class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.float :planet_rating
      t.float :people_rating
      t.float :animals_rating
      t.float :overall_rating
      t.text :description

      t.timestamps
    end
  end
end
