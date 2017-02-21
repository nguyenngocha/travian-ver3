class Server
  include Mongoid::Document
  field :_id, as: :name, type: String
  validates_uniqueness_of :_id
  belongs_to :domain
end
