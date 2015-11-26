class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users
end
