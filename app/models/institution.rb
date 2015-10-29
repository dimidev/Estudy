class Institution
  include Mongoid::Document
  include Mongoid::Paperclip

  field :title,           type: String
  field :foundation_date, type: Integer

  has_mongoid_attached_file :institution_logo, style:{medium:'150x150',thumb:'60x60'},
                            url:"/system/:attachment/:style/:basename.:extension",
                            path:":rails_root/public/system/:attachment/:style/:basename.:extension",
                            default_url: 'institution.png'

  validates_attachment :institution_logo, content_type: {content_type: /\Aimage\/.*\Z/}, size: {less_than: 2.megabytes}
  validates_presence_of :title, :foundation_date
  validates_numericality_of :foundation_date, only_integer: true

  embeds_one :address, autobuild: true
  embeds_many :contacts
  has_one :superadmin
  has_many :departments

  accepts_nested_attributes_for :superadmin, :address, limit: 1
  accepts_nested_attributes_for :contacts, reject_if: :all_blank, allow_destroy: true
end
