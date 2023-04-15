class Api::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :error_response
  rescue_from ActiveRecord::RecordInvalid, with: :error_response
  rescue_from ActionController::ParameterMissing, with: :error_response
  rescue_from ActionController::BadRequest, with: :error_response

  def error_response(exception)
    error_serializer = ErrorSerializer.new(exception)
    render json: error_serializer.error, status: error_serializer.status
  end
end