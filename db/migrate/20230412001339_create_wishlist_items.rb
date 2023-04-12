class CreateWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :wishlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :api_item_id
      t.boolean :purchased
      t.boolean :received

      t.timestamps
    end
  end
end
