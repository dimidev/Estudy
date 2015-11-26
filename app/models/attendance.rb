class Attendance
  include Mongoid::Document
  include Mongoid::Datatable
  include Mongoid::Timestamps
  extend Enumerize

  field :date, type: DateTime

  embedded_in :exam_course
  embedded_in :course_class
  has_and_belongs_to_many :students, inverse_of: nil
end
