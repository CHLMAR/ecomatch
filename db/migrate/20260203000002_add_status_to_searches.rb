class AddStatusToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :status, :string, default: "pending"
  end
end
