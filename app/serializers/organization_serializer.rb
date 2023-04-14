class OrganizationSerializer
  include JSONAPI::Serializer
  attributes :name,
             :street_address,
             :city,
             :state,
             :zip_code,
             :email,
             :phone_number,
             :website
end
