class Api::V1::WishlistItemsController < Api::ApiController
  def index
    if params[:user_id] && params[:modifier] == "unpurchased"
      render json: WishlistItemSerializer.new(WishlistItem.unpurchased_by_user(params[:user_id])), status: 201
    elsif params[:user_id] && params[:modifier] == "donated"
      render json: WishlistItemSerializer.new(WishlistItem.donated_items(params[:user_id])), status: 201
		elsif params[:user_id]
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
		if params[:donor_id]
			DonorItem.create!(donor_id: params[:donor_id], wishlist_item_id: wishlist_item_params[:id])
		end
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
		params.require(:wishlist_item).permit(:id, :recipient_id, :name, :size, :image_path, :price, :api_item_id, :purchased, :received)
	end
end