class Headline < Volt::Model
	own_by_user
	field :body, String
	field :created_at
	belongs_to :user
	permissions(:read, :create) {allow}
	permissions(:delete, :update) {deny unless owner?}

	before_save :update_time

	def update_time
		# Volt.logger.info "called before save at " + Time.now.to_s
		self.created_at = Time.now.to_s
	end
end
