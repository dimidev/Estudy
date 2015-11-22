class ProgrammeRule
  include Mongoid::Document
  extend Enumerize

  OPERATORS = %w(> >= = < <=)

  # TODO modify programme rules
  field :max_ects,            type: Integer
  field :free_semester,       type: Integer
  field :evend_odd_semester,  type: Boolean

  field :course_type
  enumerize :course_type, in: Course::COURSE_TYPE
  field :operator
  enumerize :operator, in: ProgrammeRule::OPERATORS
  field :value, type: Integer

  embedded_in :studies_programme
end
