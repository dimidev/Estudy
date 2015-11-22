class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  after_initialize :defaults
  before_save :save_courses

  attr_accessor :course_ids, :course_class_ids

  field :grade, type: Float

  validates_numericality_of :grade, greater_or_equal_than: 0, less_or_equal_to: 10, if: lambda{|attr| attr.grade.present?}

  has_many :registrations, as: :course_registration, dependent: :destroy
  belongs_to :course_registration, polymorphic: true

  belongs_to :student
  belongs_to :timetable
  belongs_to :course
  belongs_to :course_class

  accepts_nested_attributes_for :registrations, allow_destroy: true, reject_if: :all_blank

  # FIXME for some reason Timetable.current not return id
  def self.current
    where(timetable_id: self.department.timetables.current)
  end

  # OPTIMIZE
  def save_courses
    course_ids.reject!{|attr| attr.empty?}
    course_class_ids.reject!{|attr| attr.empty?}

    if self.new_record?
      course_ids.each do |c|
        registration = Registration.new(course_id: c)
        course_class_ids.each do |course_class|
          registration.course_class_id = course_class if CourseClass.find(course_class).course_id.to_s == c
        end
        self.registrations << registration
      end
    else
      course_ids.each do |c|
        if self.registrations.where(course_id: c).exists?
          course_class_ids.each do |course_class|
            self.registrations.find_by(course_id: c).update_attribute(:course_class_id, course_class) if CourseClass.find(course_class).course_id.to_s == c
          end

          self.registrations.where(:course_class_id.nin => course_class_ids, :course_class_id.ne => nil).update_all(course_class_id: nil)
        else
          registration = Registration.new(course_id: c)
          course_class_ids.each do |course_class|
            registration.course_class_id = course_class if CourseClass.find(course_class).course_id.to_s == c
          end
          self.registrations << registration
        end
      end

      self.registrations.where(:course_id.nin => course_ids, grade: nil).delete_all
    end
  end

  private

  #FIXME timetable from department
  def defaults
    self.timetable ||= Timetable.current
    self.course_ids = self.registrations.map(&:course_id) unless self.new_record?
    self.course_class_ids = self.registrations.map(&:course_class_id) unless self.new_record?
    self.course_ids ||= []
    self.course_class_ids ||= []
  end
end
