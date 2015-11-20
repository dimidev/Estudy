class Notice
  include Mongoid::Document
  include Mongoid::Datatable
  include Mongoid::Timestamps
  extend Enumerize
  extend ActiveModel::Naming

  before_save :check_department

  TARGETS = %w(institution department admins professors students)

  field :title, type: String
  field :content, type: String
  field :target
  enumerize :target, in: TARGETS

  validates :title, presence: true, length: {maximum: 256}
  validates_presence_of :target
  validate :ensure_department

  belongs_to :department

  private
  def check_department
    self.department_id = nil unless self.target == 'department'
  end

  def ensure_department
    if target == 'department' && department_id.blank?
      errors[:department] << I18n.t('mongoid.errors.models.notice.attributes.department_id')
    end
  end
end
