class Institution
  include Mongoid::Document
  include Mongoid::Paperclip

  attr_accessor :delete_img
  before_validation {institution_logo.clear if delete_img == '1' }

  field :title,           type: String
  field :foundation_date, type: Integer

  has_mongoid_attached_file :institution_logo, styles:{medium:'300x300>',thumb:'60x60>'},
                            url:"/system/:attachment/:style/institution.:extension",
                            path:":rails_root/public/system/:attachment/:style/institution.:extension",
                            default_url: 'institution.png'

  validates_attachment :institution_logo, content_type: {content_type: /\Aimage\/.*\Z/}, size: {less_than: 2.megabytes}
  validates_presence_of :title, :foundation_date
  validates_numericality_of :foundation_date, only_integer: true

  embeds_one :address, autobuild: true
  embeds_many :contacts
  has_one :superadmin
  has_many :departments
  has_many :notices

  accepts_nested_attributes_for :superadmin, :address, limit: 1
  accepts_nested_attributes_for :contacts, reject_if: :all_blank, allow_destroy: true
end
