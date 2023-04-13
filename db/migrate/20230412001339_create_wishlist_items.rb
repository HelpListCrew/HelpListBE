class CreateWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :wishlist_items do |t|
      t.belongs_to :recipient, null: false, foreign_key: { to_table: :users }
      t.integer :api_item_id
      t.boolean :purchased
      t.boolean :received

      t.timestamps
    end
  end
end
