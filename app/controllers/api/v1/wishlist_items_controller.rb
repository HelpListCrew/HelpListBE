class Api::V1::WishlistItemsController < Api::ApiController
  def index
    render json: WishlistItemSerializer.new(WishlistItem.all) 
  end
  
  def show
    render json: WishlistItemSerializer.new(WishlistItem.find(params[:id]))
  end
end