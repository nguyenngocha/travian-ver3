class Domain
  include Mongoid::Document
  field :name, type: String
  has_many :servers, dependent: :destroy
end
