class Timetable
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize

  TIMETABLE_TYPE = %w(registrations registrations_modification exams lab_exams other)

  field :period,   type: String
  field :title,   type: String
  field :type
  enumerize :type, in: TIMETABLE_TYPE
  field :from,    type: Date
  field :to,      type: Date

  validates_presence_of :from, :to
  validates_presence_of :period, if: lambda{|obj| obj.has_child_timetables? }
  validates_presence_of :type, if: lambda{|obj| obj.has_parent_timetable?}

  recursively_embeds_many
  belongs_to :department
  has_many :registrations
  has_many :exams

  def self.current
    where(:from.lte => Date.current, :to.gte => Date.current).first
  end

  def current?
    from <= Date.current && self.to >= Date.current
  end

  accepts_nested_attributes_for :child_timetables, reject_if: :all_blank, allow_destroy: true
end
