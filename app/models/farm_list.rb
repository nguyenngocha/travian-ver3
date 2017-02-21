class FarmList
  include Mongoid::Document
  field :name, type: String
  field :village_id, type: Integer
  field :village_name, type: String
  field :status, type: Mongoid::Boolean, default: true

  validates :village_id, presence: true
  validates :name, length: {maximum: 15}
  embedded_in :account, inverse_of: :farm_lists
  embeds_many :farms
  accepts_nested_attributes_for :farms, allow_destroy: true,
    reject_if: ->(attrs){ attrs[:x] == "" || attrs[:y] == "" }

  before_create :add_village_name

  private
  def add_village_name
    village = self.account.villages.find self.village_id
    if village
      self.village_name = village.name
    end
  end
end
