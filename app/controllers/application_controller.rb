class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActionController::BadRequest, with: :bad_request_response
  rescue_from CustomRecordNotFound, with: :custom_not_found_response

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404)
    ).serialize_json, status: :not_found
  end

  def bad_request_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 400)
    ).serialize_json, status: :bad_request
  end

  def custom_not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404, exception.data)
    ).serialize_json, status: :not_found
  end
end
