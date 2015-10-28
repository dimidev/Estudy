class StudiesProgramme
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize

  field :diploma_title,   type: String
  field :studies_level
  enumerize :studies_level, in: [:undergraduate , :postgraduate], default: :undergraduate
  field :fees,            type: Boolean,      default: false
  field :orientation,     type: Boolean,      default: false
  field :semesters,       type: Integer
  field :active,          type: Boolean,      default: true

  validates_presence_of :diploma_title, :studies_level, :semesters
  validates_numericality_of :semesters, only_integer: true, greater_than: 0

  embeds_many :programme_rules
  has_many :courses,            dependent: :restrict
  belongs_to :department

  accepts_nested_attributes_for :programme_rules, :courses, allow_destroy: true, reject_if: :all_blank
end
