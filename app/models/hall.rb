class Hall
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  field :name,  type: String
  field :area,  type: Integer, default: 0
  field :floor, type: Integer, default: 0
  field :type
  enumerize :type, in: [:office, :lab, :hall, :auditorium]

  field :pc,    type: Integer, default: 0
  field :seats, type: Integer, default: 0
  field :office_desks, type: Integer, default: 0

  validates_associated :building
  validates_presence_of :name, :type, :area, :floor
  validates_numericality_of :area, :floor, only_integer: true, greater_or_equal_to: 0

  validates :pc, presence: true, numericality:{only_integer: true, greater_or_equal_to: 0}, if: lambda{|obj| %w(office lab).include?(obj.type)}
  validates :seats, presence: true, numericality:{only_integer: true, greater_or_equal_to: 0}, if: lambda{|obj| %w(lab hall auditorium).include?(obj.type)}
  validates :office_desks, presence: true, numericality:{only_integer: true, greater_or_equal_to: 0}, if: lambda{|obj| obj.type == 'office'}

  belongs_to :building
  has_many :professors, as: :professor_office, class_name:'Professor'
  has_and_belongs_to_many :exam_courses

  scope :offices, lambda{where(type: :office)}
  scope :halls, lambda{where(type: :hall)}
  scope :labs, lambda{where(type: :lab)}
  scope :auditoriums, lambda{where(type: :auditorium)}

  default_scope lambda{order_by(type: :asc)}

  def self.available_offices
    where(type: :office).select{|office| office if office.office_desks > office.professors.count}
  end
end
