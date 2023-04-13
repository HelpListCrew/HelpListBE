class WishlistItemSerializer
  include JSONAPI::Serializer
  attributes :api_item_id, :purchased, :received
end
