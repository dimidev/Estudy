class Notice
  include Mongoid::Document
  include Mongoid::Datatable
  include Mongoid::Timestamps
  extend Enumerize
  extend ActiveModel::Naming

  TARGETS = %w(institution department admins professors students)

  field :title, type: String
  field :content, type: String
  field :target
  enumerize :target, in: TARGETS

  validates :title, presence: true, length: {maximum: 256}
  validates_presence_of :target

  belongs_to :department
end
