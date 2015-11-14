class Attendance
  include Mongoid::Document

  belongs_to :student
  belongs_to :course_class
  belongs_to :exam
end
