class ExamCourse
  include Mongoid::Document
  include Mongoid::Datatable

  attr_reader :exam_day

  field :day,   type: Date
  field :from,  type: Time
  field :to,    type: Time

  validates_presence_of :day

  belongs_to :exam
  belongs_to :course_class
  belongs_to :course
  has_and_belongs_to_many :halls
  has_and_belongs_to_many :professors

  default_scope lambda{order_by(from: :desc)}

  def exam_day
    "#{day.strftime('%d-%m-%Y')} (#{from.to_s(:time)} - #{to.to_s(:time)})"
  end
end
