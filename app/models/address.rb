class Address
  include Mongoid::Document

  field :country,     type: String
  field :city,        type: String
  field :postal_code, type: String
  field :address,     type: String
  field :primary,     type: Boolean, default: true

  validates_presence_of :country, :city, :postal_code, :address

  embedded_in :institution, autobuild: true
  embedded_in :department
  embedded_in :user
end
