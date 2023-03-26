class AddNextPlaceToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :next_place, :string
  end
end
