class Api::V1::OrganizationsController < Api::ApiController
  def index
    render json: OrganizationSerializer.new(Organization.all)
  end
end