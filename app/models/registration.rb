class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  belongs_to :student
  has_and_belongs_to_many :courses, inverse_of: nil
end
