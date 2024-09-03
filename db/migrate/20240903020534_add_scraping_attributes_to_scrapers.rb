class AddScrapingAttributesToScrapers < ActiveRecord::Migration[7.2]
  def change
    add_column :scrapers, :list_xpath, :string
    add_column :scrapers, :children_css, :string
    add_column :scrapers, :target_tags, :json
  end
end
