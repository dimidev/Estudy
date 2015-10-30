class Notice
  include Mongoid::Document
  include Mongoid::Datatable
  extend Enumerize

  field :title, type: String
  field :target
  enumerize :target, in: [:institution, :departments, :admins, :professors, :students]
  field :content, type: String

  validates_presence_of :title, :target

  belongs_to :institution
  belongs_to :department
  belongs_to :course
  belongs_to :admin
  belongs_to :professor
  belongs_to :student
end
