class ErrorMessage
    attr_reader :message, :status_code, :data
  
    def initialize(message, status_code, data = [])
        @message = message
        @status_code = status_code
        @data = data
    end
  
end