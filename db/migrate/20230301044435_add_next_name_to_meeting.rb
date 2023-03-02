class AddNextNameToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :next_name, :string
  end
end
