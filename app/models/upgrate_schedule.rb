class UpgrateSchedule
  include Mongoid::Document
  field :village_id, type: Integer
  field :upgrate_id, type: Integer
  field :upgrate_name, type: String
  field :upgrate_time, type: Date

  validates :village_id, presence: true
  validates :upgrate_id, presence: true, length: {maximum: 40, minimum: 1}
  embedded_in :village, inverse_of: :upgrate_schedules

  # before_create :add_village_name
end
