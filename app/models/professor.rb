class Professor < User
  after_initialize :defaults

  PROFESSOR_TYPE = %w(professor_emeritus professor associate_professor assistant_professor lecturer lab_assistant)

  field :professor_type
  enumerize :professor_type, in: PROFESSOR_TYPE

  validates_presence_of :professor_type

  belongs_to  :department
  embeds_many :office_times
  has_many    :course_classes
  has_and_belongs_to_many :exam_courses

  # FIXME association saved like string, not like BSON:ObjectID
  belongs_to :professor_office, class_name:'Hall', polymorphic: true

  accepts_nested_attributes_for :office_times, allow_destroy: true, reject_if: :all_blank

  private
  def defaults
    self.role = :professor
  end
end
