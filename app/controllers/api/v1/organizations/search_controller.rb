class Api::V1::Organizations::SearchController < Api::ApiController
  def index
    org = Organization.find_orgs_near_me(params[:address], params[:miles])
    if ( params[:address].blank? && params[:miles].blank? ) || ( params[:address].blank? || params[:miles].blank? )
      render json: { errors: [ { title: 'ActionController::BadRequest' } ] }, status: 400
    elsif org == []
      render json: { data: {} }
    else
      render json: OrganizationSerializer.new(org)
    end
  end
end