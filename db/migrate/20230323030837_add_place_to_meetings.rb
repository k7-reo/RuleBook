class AddPlaceToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :place, :string
  end
end
