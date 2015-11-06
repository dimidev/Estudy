class Hall
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  field :name,  type: String
  field :area,  type: Integer, default: 0
  field :floor, type: Integer, default: 0
  field :type
  enumerize :type, in: [:office, :lab, :auditorium]

  field :pc,    type: Integer
  field :seats, type: Integer

  validates_associated :building
  validates_presence_of :name, :type, :area, :floor
  validates_numericality_of :area, :floor, only_integer: true, greater_or_equal_to: 0

  validates :pc, presence: true, numericality:{only_integer: true, greater_or_equal_to: 0}, if: lambda{|obj| %w(office lab).include?(obj.type)}
  validates :seats, presence: true, numericality:{only_integer: true, greater_or_equal_to: 0}, if: lambda{|obj| %w(lab auditorium).include?(obj.type)}

  belongs_to :building
end
