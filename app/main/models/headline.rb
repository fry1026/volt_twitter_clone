class Headline < Volt::Model
	own_by_user
	field :body, String
	permissions(:read, :create) {allow}
	permissions(:delete, :update) {deny unless owner?}
end
