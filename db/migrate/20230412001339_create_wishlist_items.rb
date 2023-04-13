class CreateWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :wishlist_items do |t|
      t.belongs_to :recipient, null: false, foreign_key: { to_table: :users }
      t.integer :api_item_id
      t.boolean :purchased, default: false
      t.boolean :received, default: false

      t.timestamps
    end
  end
end
