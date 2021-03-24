class CreateScrapedLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :scraped_links do |t|
      t.string :title
      t.string :link
      t.boolean :is_scraped, default: false
      
      t.timestamps
    end
  end
end
