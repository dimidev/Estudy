class Student < User
  #before_create :auto_increment
  after_initialize :defaults

  field :semester,  type: Integer, default: 1
  field :stc,       type: Integer # Student Code

  validates_associated :department
  validates_presence_of :semester
  validates_numericality_of :semester, only_integer: true, greater_than_or_equal_to: 1

  validates_associated :studies_programme
  has_many :registrations
  belongs_to :studies_programme
  belongs_to :department

  private
  def defaults
    self.role= :student
  end

  def auto_increment
    if self.new_record?
    end
  end
end
