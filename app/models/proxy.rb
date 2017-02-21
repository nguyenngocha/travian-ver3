class Proxy
  include Mongoid::Document
  field :_id, as: :ip, type: String
  field :port, type: Integer
  field :status, type: Mongoid::Boolean, default: true
  field :used, type: Mongoid::Boolean, default: false
  validates_uniqueness_of :id

  # scope :first_element, -> { where(used: false, status: true).first}

  class << self
    def first_element
      where(used: false, status: true).first
    end
  end
end
