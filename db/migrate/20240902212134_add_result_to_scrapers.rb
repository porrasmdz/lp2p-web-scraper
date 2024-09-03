class AddResultToScrapers < ActiveRecord::Migration[7.2]
  def change
    add_column :scrapers, :result, :json
  end
end
