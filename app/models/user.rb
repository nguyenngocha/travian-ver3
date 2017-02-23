class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable, :validatable
  field :email, type: String, default: ""
  field :ip, type: String
  field :port, type: Integer
  field :is_admin, type: Mongoid::Boolean, default: false
  field :encrypted_password, type: String, default: ""
  embeds_many :accounts
end
