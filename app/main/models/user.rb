# By default Volt generates this User model which inherits from Volt::User,
# you can rename this if you want.
class User < Volt::User
  # login_field is set to :email by default and can be changed to :username
  # in config/app.rb
  field login_field
  field :name
  validate login_field, unique: true, length: 8
  validate :email, email: true
  has_many :headlines
  field :admin, String #default no

  before_validate :set_default_admin_to_false

  def set_default_admin_to_false
    self.admin='false' unless admin
  end
end
