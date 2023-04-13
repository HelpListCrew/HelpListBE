class Api::V1::WishlistItemsController < Api::ApiController
  def show
    render json: WishlistItemSerializer.new(WishlistItem.find(params[:id]))
  end
end