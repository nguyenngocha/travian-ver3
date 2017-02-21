class Account
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :t3e, type: String
  field :race, type: String
  field :sess_id, type: String
  field :ajax_token, type: String
  field :player_uuid, type: String
  field :active, type: Integer
  field :server_id, type: String
  embedded_in :user, inverse_of: :accounts
  embeds_many :villages
  embeds_many :farm_lists
end
