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
  validate :check_day

  belongs_to :department
  belongs_to :course
  belongs_to :professor
  belongs_to :hall
  has_many   :registrations
  belongs_to :timetable
  has_one   :exam_course

  private
  def check_day
    errors[:hall] << I18n.t('mongoid.errors.models.course_class.hall.not_available')  if CourseClass.where(hall_id: hall_id, day: day).or([:from.lt=>from, :to.gt=>from], [:from.lt=>to, :to.gt=>to]).exists?
    errors[:professor] << I18n.t('mongoid.errors.models.course_class.professor.not_available') if CourseClass.where(professor_id: professor_id).or([:from.lt=>from, :to.gt=>from], [:from.lt=>to, :to.gt=>to]).exists?
  end
end
