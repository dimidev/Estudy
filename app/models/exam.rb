class Exam
  include Mongoid::Document

  field :date, type: DateTime

  belongs_to :department
  belongs_to :timetable
  belongs_to :hall
  has_many :attendances
end
