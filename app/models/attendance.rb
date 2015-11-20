class Attendance
  include Mongoid::Document
  include Mongoid::Datatable
  include Mongoid::Timestamps
  extend Enumerize

  belongs_to :student
  belongs_to :course_class
  belongs_to :exam
end
