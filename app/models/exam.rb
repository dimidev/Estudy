class Exam
  include Mongoid::Document
  include Mongoid::Datatable

  before_create :check_timetable_period

  after_initialize :defaults

  attr_accessor :lab_start, :lab_end, :theory_start, :theory_end

  field :date, type: DateTime

  validate :validate_dates

  has_many :exams, as: :parent_exam
  belongs_to :parent_exam, polymorphic: true

  belongs_to :department
  belongs_to :timetable
  belongs_to :hall
  has_many :attendances

  private
  def defaults
    self.timetable ||= Timetable.current
    if self.timetable.child_timetables.where(type: 'lab_exams').exists?
      self.lab_start = self.timetable.child_timetables.find_by(type: 'lab_exams').from
      self.lab_end = self.timetable.child_timetables.find_by(type: 'lab_exams').to
    end
    if self.timetable.child_timetables.where(type: 'theory_exams').exists?
      self.theory_start = self.timetable.child_timetables.find_by(type: 'theory_exams').from
      self.theory_end = self.timetable.child_timetables.find_by(type: 'theory_exams').to
    end
  end

  # TODO check dates to not be the same period .. labs with thories
  def validate_dates

  end

  # TODO check if period exists or changed then update it on timetables
  def check_timetable_period
  end
end
