class CreateUserWishlistItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_wishlist_items do |t|
      t.references :wishlist_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
