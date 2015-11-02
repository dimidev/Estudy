class Notice
  include Mongoid::Document
  include Mongoid::Datatable
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String

  validates :title, presence: true, length: {maximum: 256}

  belongs_to :institution
  belongs_to :department
  belongs_to :course
  belongs_to :admin
  belongs_to :professor
  belongs_to :student
end
