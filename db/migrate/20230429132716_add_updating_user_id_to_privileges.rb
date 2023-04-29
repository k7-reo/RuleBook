class AddUpdatingUserIdToPrivileges < ActiveRecord::Migration[6.1]
  def change
    add_column :privileges, :updating_user_id, :integar
  end
end
