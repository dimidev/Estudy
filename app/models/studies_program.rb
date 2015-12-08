class StudiesProgram
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  field :diploma_title,   type: String
  field :studies_level
  enumerize :studies_level, in: [:undergraduate , :postgraduate], default: :undergraduate
  field :semesters,       type: Integer
  field :status
  enumerize :status, in: {active: true, not_active: false}, default: :active

  validates_presence_of :diploma_title, :studies_level, :semesters
  validates_numericality_of :semesters, only_integer: true, greater_than: 0

  has_many :courses,            dependent: :restrict
  belongs_to :department

  accepts_nested_attributes_for :courses, allow_destroy: true, reject_if: :all_blank
end
