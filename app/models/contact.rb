class Contact
  include Mongoid::Document
  extend Enumerize

  field :type
  field :value, type: String
  enumerize :type, in: [:phone, :fax, :email]

  validates_presence_of :type, :value

  embedded_in :institution
  embedded_in :department
end
