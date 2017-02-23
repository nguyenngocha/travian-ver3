class Village
  include Mongoid::Document
  field :_id, as: :newdid, type: Integer
  field :x, type: Integer
  field :y, type: Integer
  field :name, type: String
  validates_uniqueness_of :_id
  embedded_in :account, inverse_of: :villages
  embeds_many :upgrate_schedules

  accepts_nested_attributes_for :upgrate_schedules, allow_destroy: true
end
