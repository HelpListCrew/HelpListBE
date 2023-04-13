class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uid, :string, default: SecureRandom.hex(15)
  end
end
