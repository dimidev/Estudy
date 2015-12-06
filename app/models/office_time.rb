class OfficeTime
  include Mongoid::Document
  extend Enumerize
  extend ActiveModel::Naming

  DAYS = %w(monday tuesday wednesday thursday friday)

  field :day
  enumerize :day, in: DAYS
  field :from,  type: Time
  field :to,    type: Time

  validates_presence_of :day, :from, :to

  embedded_in :professor
end
