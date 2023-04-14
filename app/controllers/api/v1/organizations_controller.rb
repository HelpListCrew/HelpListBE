class Api::V1::OrganizationsController < Api::ApiController
  def index
    render json: OrganizationSerializer.new(Organization.all)
  end

  def show
    render json: OrganizationSerializer.new(Organization.find(params[:id]))
  end

  def create
    organization = Organization.new(organization_params)

		if organization.save
    	render json: OrganizationSerializer.new(organization), status: 201
		else
			render json: ErrorSerializer.new(organization).user_error, status: 400
    end
  end

  def update
    organization = Organization.find(params[:id])

    organization.update!(organization_params)

    render json: OrganizationSerializer.new(organization)
  end

  private
	def organization_params
		params.require(:organization).permit(:name, :street_address, :city, :state, :zip_code, :email, :phone_number, :website )
	end
end