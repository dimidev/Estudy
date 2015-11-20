class Student < User
  before_create :auto_increment
  after_initialize :defaults

  attr_readonly :stc

  field :semester,  type: Integer, default: 1
  field :stc,       type: Integer # Student Code
  field :status
  enumerize :status, in: [:active, :not_active, :postponement, :graduate], default: :active

  validates_associated :department, :studies_programme
  validates_presence_of :semester, :status
  validates_numericality_of :semester, only_integer: true, greater_than_or_equal_to: 1

  validates_associated :studies_programme
  has_many    :registrations
  belongs_to  :studies_programme
  belongs_to  :department
  embeds_many :grades
  has_many    :attendances, dependent: :destroy

  scope :active, lambda{ where(status: :active) }

  def available_courses
    parent_courses = self.studies_programme.courses.pluck(:id)
    child_courses = Course.where(parent_course_id: {'$in'=> parent_courses})
    Course.or([studies_programme_id: self.studies_programme, id: {'$nin'=> child_courses.pluck(:parent_course_id).uniq}], [id: {'$in'=> child_courses.pluck(:id)}])
  end

  private
  def defaults
    self.role= :student
  end

  def auto_increment
    if Student.exists?
      self.stc = Student.order_by(stc: :desc).first.stc.to_i + 1
    else
      self.stc = 1
    end
  end
end
