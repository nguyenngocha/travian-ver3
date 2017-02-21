class Farm
  include Mongoid::Document
  field :land_id, type: Integer
  field :x, type: Integer
  field :y, type: Integer
  field :army1, type: Integer
  field :army2, type: Integer
  field :army3, type: Integer
  field :army4, type: Integer
  field :army5, type: Integer
  field :army6, type: Integer
  field :army7, type: Integer
  field :army8, type: Integer
  field :army9, type: Integer
  field :army10, type: Integer
  field :army11, type: Integer
  field :distance, type: Integer
  field :status, type: Mongoid::Boolean, default: true

  validates :x, presence: true
  validates :y, presence: true

  embedded_in :farm_list, inverse_of: :farms

  before_save :add_attributes

  private
  def add_attributes
    village = self.farm_list.account.villages.find self.farm_list.village_id
    self.distance = (Math.sqrt((village.x - self.x).abs**2 + (village.y - self.y).abs**2)).round(1)
    self.land_id = ((-400 - self.x).abs + 1 + (400 - self.y).abs*801)
  end
end
