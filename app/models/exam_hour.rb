class ExamHour
  include Mongoid::Document

  field :from, type: Time
  field :to, type: Time

end
