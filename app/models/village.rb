class Village
  include Mongoid::Document
  field :_id, as: :newdid, type: Integer
  field :x, type: Integer
  field :y, type: Integer
  field :name, type: String
  validates_uniqueness_of :_id
  embedded_in :account, inverse_of: :villages
end
