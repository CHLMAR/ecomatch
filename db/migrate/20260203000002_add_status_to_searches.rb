class AddStatusToSearches < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:searches, :status)
      add_column :searches, :status, :string, default: "pending"
    end
  end
end
