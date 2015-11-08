class Professor < User
  after_initialize :defaults

  PROFESSOR_TYPE = %w(professor_emeritus professor associate_professor assistant_professor lecturer lab_assistant)

  field :professor_type
  enumerize :professor_type, in: PROFESSOR_TYPE

  validates_associated :departments
  validates_presence_of :professor_type

  has_and_belongs_to_many :departments, inverse_of: nil

  # FIXME association saved like string, not like BSON:ObjectID
  belongs_to :professor_office, class_name:'Hall', polymorphic: true

  private
  def defaults
    self.role = :professor
  end
end
