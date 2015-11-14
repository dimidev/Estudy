class Grade
  include Mongoid::Document

  embedded_in :student
end
