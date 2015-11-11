class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  field :grade, type: Float

  validates_numericality_of :grade, greater_or_equal_than: 0, less_or_equal_to: 10, if: lambda{|attr| attr.grade.present?}

  recursively_embeds_many
  belongs_to :student
  belongs_to :timetable
  belongs_to :course

  accepts_nested_attributes_for :child_registrations, allow_destroy: true, reject_if: :all_blank
end
