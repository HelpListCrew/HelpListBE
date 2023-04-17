class WishlistItemSerializer
  include JSONAPI::Serializer
  attributes :api_item_id, :purchased, :received, :size, :name, :price, :image_path
end
