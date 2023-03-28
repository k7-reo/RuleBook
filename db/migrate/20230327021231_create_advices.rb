class CreateAdvices < ActiveRecord::Migration[5.2]
  def change
    create_table :advices do |t|
      t.string :quote
      t.string :person
      t.string :biography
      t.string :community_genre
      t.timestamps
    end
  end
end
