class StudiesProgramme
  include Mongoid::Document

  has_many :students
end
