class ProgrammeRule
  include Mongoid::Document
  extend Enumerize

  OPERATORS = %w(> >= = < <=)

  field :course_type
  enumerize :course_type, in: Course::COURSE_TYPE
  field :operator
  enumerize :operator, in: ProgrammeRule::OPERATORS
  field :value, type: Integer

  embedded_in :studies_programme
end
