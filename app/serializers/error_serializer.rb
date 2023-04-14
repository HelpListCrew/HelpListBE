class ErrorSerializer
	attr_reader :status

	def initialize(object)
		@object = object
		@status = status
	end

  def self.failed_auth
    {
			message: "your query could not be completed",
			errors: [{
				"status": 401,
				"title": "Invalid credentials"
			}]
		}
  end

	def user_error
		hash = {
			message: "your query could not be completed",
			errors: []
		}
		@object.errors.each do |error|
			hash[:errors] << {
				"status": status.to_s,
				"title": error.full_message
			}
		end
		hash
	end

	def error
		{
		 	message: "your query could not be completed",
			errors: [
					{
			 			status: status.to_s,
						title: @object.message,
					}
				]
			}
	end

  def status
    return 404 if @object.class == ActiveRecord::RecordNotFound
    400
  end
end