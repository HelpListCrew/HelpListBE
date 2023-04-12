class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :user_type, default: 0

      t.timestamps
    end
  end
end
