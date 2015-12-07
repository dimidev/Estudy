class Timetable
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize
  extend ActiveModel::Naming

  before_save :check_event_type

  TIMETABLE_TYPE = %w(registrations registrations_modification theory_exams lab_exams other)

  field :period,    type: String
  field :title,     type: String
  field :type
  enumerize :type, in: TIMETABLE_TYPE
  field :from,      type: Date
  field :to,        type: Date

  index({period: 1},{unique: true, background: true})

  validates_presence_of :from, :to
  validates_presence_of :title, if: lambda{|obj| obj.type == 'other'}
  validates_presence_of :period, if: lambda{|obj| obj.has_child_timetables? }
  validates_presence_of :type, if: lambda{|obj| obj.has_parent_timetable?}
  validates_uniqueness_of :type, unless: lambda{|obj| obj.type == 'other' || obj.has_child_timetables?}

  recursively_embeds_many
  belongs_to :department
  has_many :registrations
  has_many :exam
  has_many :course_classes,   dependent: :restrict

  default_scope lambda{order_by(from: :desc)}

  def self.current
    where(:from.lte => Date.current, :to.gte => Date.current).first
  end

  def current?
    from <= Date.current && self.to >= Date.current
  end

  accepts_nested_attributes_for :child_timetables, reject_if: :all_blank, allow_destroy: true

  private
  def check_event_type
    self.title = nil unless self.type == 'other'
  end
end
