class Contact
  include Mongoid::Document
  extend Enumerize

  field :type
  field :value, type: String
  enumerize :type, in: [:phone, :fax, :email]

  validates_presence_of :type, :value
  validates :value, format: {with: Devise::email_regexp}, if: lambda{|attr| attr.type == 'email'}

  embedded_in :institution
  embedded_in :department
  embedded_in :admin
end
