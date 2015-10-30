class Course
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize

  COURSE_TYPE = %w(compulsory specification selection_required foreign_language)
  COURSE_PART = %w(theory lab)

  field :title,         type: String
  field :description,   type: String
  enumerize :course_type, in: COURSE_TYPE
  enumerize :course_part, in: COURSE_PART
  field :semester,      type: String,   default: 1
  field :ects,          type: Integer
  field :hours,         type: Integer, default: 0
  field :percent,       type: Integer

  validates_presence_of :title, :hours
  validates :ects, presence: true, numericality: {integer_only: true, greater_than_equal_to: 0}, unless: lambda{ |obj| obj.has_parent_course? }

  belongs_to :studies_programme
  has_many   :courses, as: :parent_course
  belongs_to :parent_course, polymorphic: true
  has_many :notice

  accepts_nested_attributes_for :courses, reject_if: :all_blank, allow_destroy: true
end
