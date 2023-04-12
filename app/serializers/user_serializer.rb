class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :user_type
end
