class ErrorSerializer
	def initialize(object, status=404)
		@object = object
		@status = status
	end

	def user_error
		hash = {
			message: "your query could not be completed",
			errors: []
		}
		@object.errors.each do |error|
			hash[:errors] << {
				"status": @status.to_s,
				"title": error.full_message
			}
		end
		hash
	end

	def self.failed_auth
		{
			message: "your query could not be completed",
			errors: {
				"status": 404,
				"title": "Not authenticated"
			}
		}
	end
end