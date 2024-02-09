class ErrorSerializer
  include JSONAPI::Serializer

  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      errors: [
        {
          status: @error_object.status_code,
          message: @error_object.message,
        }
      ],
      data: {
          result: nil
      }
    }
  end

end