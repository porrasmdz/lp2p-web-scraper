class AddRawHtmlToScrapers < ActiveRecord::Migration[7.2]
  def change
    add_column :scrapers, :raw_html, :text
  end
end
