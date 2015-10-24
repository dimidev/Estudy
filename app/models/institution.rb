class Institution
  include Mongoid::Document
  include Mongoid::Paperclip

  field :title,           type: String
  field :short_title,     type: String
  field :foundation_date, type: Integer

  validates_presence_of :title, :foundation_date
  validates_numericality_of :foundation_date, only_integer: true

  has_mongoid_attached_file :institution_logo, style:{medium:'150x150',thumb:'60x60'},
                            url:"/system/:attachment/:style/:basename.:extension",
                            path:":rails_root/public/system/:attachment/:style/:basename.:extension",
                            default_url: 'institution.png'

  validates_attachment :institution_logo, content_type: {content_type: /\Aimage\/.*\Z/}, size: {less_than: 2.megabytes}

  embeds_one :address, autobuild: true
  has_one :superadmin

  accepts_nested_attributes_for :superadmin, :address, limit: 1
end
