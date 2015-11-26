class ExamCourse
  include Mongoid::Document
  include Mongoid::Datatable

  attr_reader :exam_day

  field :day,   type: Date

  validates_presence_of :day

  belongs_to :exam
  belongs_to :course_class
  belongs_to :course
  has_and_belongs_to_many :halls
  has_and_belongs_to_many :professors
  embeds_one :attendance

  default_scope lambda{order_by(from: :desc)}

  accepts_nested_attributes_for :attendance, :course_class

  def exam_day
    "#{day.strftime('%d-%m-%Y')}"
  end
end
