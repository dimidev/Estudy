class Exam
  include Mongoid::Document
  include Mongoid::Datatable

  after_initialize :defaults

  field :professor_max_attendances
  field :student_max_courses
  field :date, type: DateTime

  has_many :exams, as: :parent_exam
  belongs_to :parent_exam

  belongs_to :department
  belongs_to :timetable
  belongs_to :hall
  has_many :attendances

  private
  def defaults
    self.timetable ||= Timetable.current
  end
end
