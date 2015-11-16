class CourseClass
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  DAYS = %w(monday tuesday wednesday thursday friday)

  field :day
  enumerize :day, in: DAYS
  field :from, type: Time
  field :to, type: Time

  validates_associated :department
  validates_uniqueness_of :course_id, scope: [:professor_id, :hall_id, :day, :from, :to]
  validates_presence_of :course_id, :professor_id, :hall_id, :day, :from, :to

  belongs_to :department
  belongs_to :course
  belongs_to :professor
  belongs_to :hall
  has_many   :attendances, dependent: :destroy
  has_many   :registrations
end
