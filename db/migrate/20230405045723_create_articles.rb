class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :content_genre
      t.timestamps
    end
  end
end
