class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  belongs_to :student
end
