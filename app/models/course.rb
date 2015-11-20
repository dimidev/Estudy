class Course
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  after_initialize :defaults

  COURSE_TYPE = %w(compulsory specification selection_required foreign_language)
  COURSE_PART = %w(theory lab)

  field :title,             type: String
  enumerize :course_type, in: COURSE_TYPE
  enumerize :course_part, in: COURSE_PART
  field :semester,          type: String
  field :ects,              type: Integer
  field :hours,             type: Integer, default: 0
  field :percent,           type: Integer
  field :attendances_limit, type: Integer

  validates_presence_of :title, unless: lambda{|obj| obj.has_parent_course?}
  validates :hours, presence: true, numericality: {integer_only: true, greater_than_equal_to: 0}
  validates :ects, presence: true, numericality: {integer_only: true, greater_than_equal_to: 0}, unless: lambda{ |obj| obj.has_parent_course? }
  validates :percent, presence: true, numericality: {integer_only: true, greater_than_equal_to: 0, less_than_or_equal_to: 100}, if: lambda{ |obj| obj.has_parent_course? }
  validates :attendances_limit, presence: true, numericality: {integer_only: true, greater_than_equal_to: 0, less_than_or_equal_to: 100}, if: lambda{ |obj| obj.course_part == 'lab' }
  validate :check_ects

  belongs_to  :studies_programme
  has_many    :registrations
  has_many    :course_classes, dependent: :destroy

  has_many    :child_courses, as: :parent_course, class_name:'Course', dependent: :destroy
  belongs_to  :parent_course, polymorphic: true

  belongs_to :chain_course, class_name:'Course', inverse_of: nil

  accepts_nested_attributes_for :child_courses, reject_if: :all_blank, allow_destroy: true

  default_scope lambda{order(semester: :asc)}

  private
  def check_ects
    unless has_parent_course?
      errors[:semester] << I18n.t('mongoid.errors.models.course.attributes.semester.bigger_than_programm') if semester.to_i > studies_programme.semesters.to_i
    end
  end

  def defaults
    self.title = self.parent_course.title if self.has_parent_course?
    self.semester = self.parent_course.semester if self.has_parent_course?
  end
end
