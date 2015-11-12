class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  after_initialize :defaults
  before_save :save_courses

  attr_accessor :course_ids

  field :grade, type: Float

  validates_numericality_of :grade, greater_or_equal_than: 0, less_or_equal_to: 10, if: lambda{|attr| attr.grade.present?}

  has_many :registrations, as: :course_registration
  belongs_to :course_registration, polymorphic: true

  belongs_to :student
  belongs_to :timetable
  belongs_to :course

  accepts_nested_attributes_for :registrations, allow_destroy: true, reject_if: :all_blank

  #FIXME update not working properly
  def save_courses
    course_ids.reject!{|attr| attr.empty?}

    if self.new_record?
      course_ids.each do |c|
        self.registrations << Registration.new(course_id: c)
      end
    else
      course_ids.each do |c|
        self.registrations.where(course_id: c) || self.registrations.build(course_id: c)
      end

      self.registrations.where(course_id: {'$nin'=> course_ids}).delete_all
    end
  end

  private
  def defaults
    self.course_ids = self.registrations.map(&:course_id) unless self.new_record?
    self.course_ids ||= []
  end
end
