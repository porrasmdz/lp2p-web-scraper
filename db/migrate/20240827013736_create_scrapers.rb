class CreateScrapers < ActiveRecord::Migration[7.2]
  def change
    create_table :scrapers do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
