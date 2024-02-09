class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActionController::BadRequest, with: :handle_bad_request

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404)
    ).serialize_json, status: :not_found
  end

  def handle_bad_request(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 400)
    ).serialize_json, status: :bad_request
  end
end
