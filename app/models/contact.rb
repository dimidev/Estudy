class Contact
  include Mongoid::Document
  extend Enumerize
  extend ActiveModel::Naming

  field :type
  field :value, type: String
  enumerize :type, in: [:phone, :fax, :email]

  validates_presence_of :type, :value
  validates :value, format: {with: Devise::email_regexp}, if: lambda{|attr| attr.type == 'email'}

  embedded_in :institution
  embedded_in :department
  embedded_in :user

  scope :phones, lambda{where(type: 'phone')}
  scope :fax, lambda{where(type: 'fax')}
  scope :emails, lambda{where(type: 'email')}
end
