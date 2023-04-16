class Api::V1::WishlistItemsController < Api::ApiController
  def index
		if params[:user_id]
			render json: WishlistItemSerializer.new(WishlistItem.by_user(params[:user_id])), status: 201
		else
			render json: WishlistItemSerializer.new(WishlistItem.all) 
		end
  end
  
  def show
    render json: WishlistItemSerializer.new(WishlistItem.find(params[:id]))
  end

  def create
    wishlist_item = WishlistItem.new(wishlist_item_params)

		if wishlist_item.save
    	render json: WishlistItemSerializer.new(wishlist_item), status: 201
		else
			render json: ErrorSerializer.new(wishlist_item).user_error, status: 400
    end
  end

  def update
    wishlist_item = WishlistItem.find(params[:id])

    wishlist_item.update!(wishlist_item_params)

    render json: WishlistItemSerializer.new(wishlist_item)
  end

  def destroy
    WishlistItem.destroy(params[:id])
    render status: 204
  end

  private
	def wishlist_item_params
		params.require(:wishlist_item).permit(:recipient_id, :api_item_id, :purchased, :received)
	end
end