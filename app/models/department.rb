class Department
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Datatable

  after_initialize :defaults

  field :title,           type: String
  field :short_title,     type: String
  field :foundation_date, type: Date
  field :active,          type: Boolean, default: true

  has_mongoid_attached_file :department_logo, style:{medium:'150x150',thumb:'60x60'},
                            url:"/system/:attachment/:style/:basename.:extension",
                            path:":rails_root/public/system/:attachment/:style/:basename.:extension",
                            default_url: 'institution.png'

  validates_attachment :department_logo, content_type: {content_type: /\Aimage\/.*\Z/}, size: {less_than: 2.megabytes}
  validates_associated :institution
  validates_presence_of :title, :foundation_date

  embeds_one :address
  embeds_many :contacts
  belongs_to :institution

  accepts_nested_attributes_for :address, :contacts, reject_if: :all_blank, allow_destroy: true

  scope :active, lambda { where(active: true) }

  private
  def defaults
    self.short_title ||= self.title
  end
end