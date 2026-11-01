class AddRoleAndDisplayNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, null: false, default: "user"
    add_column :users, :display_name, :string
  end
end
