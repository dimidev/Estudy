class CourseClass
  include Mongoid::Document

  belongs_to :department
  belongs_to :course
  belongs_to :professor
  has_manu   :attendances
end
