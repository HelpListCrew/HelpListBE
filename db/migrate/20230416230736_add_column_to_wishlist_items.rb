class AddColumnToWishlistItems < ActiveRecord::Migration[7.0]
  def change
    add_column :wishlist_items, :image_path, :string
    add_column :wishlist_items, :name, :string
    add_column :wishlist_items, :price, :float
    add_column :wishlist_items, :size, :string
  end
end
