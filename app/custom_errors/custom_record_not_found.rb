class CustomRecordNotFound < ActiveRecord::RecordNotFound
  def initialize(message, data)
    super(message)
    @data = data
  end
end