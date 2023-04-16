class Api::V1::Organizations::SearchController < Api::ApiController
  def index
    org = Organization.find_orgs_near_me(params[:address], params[:miles])
    render json: OrganizationSerializer.new(org)
  end
end