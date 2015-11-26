class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :content, type: String

  embedded_in :conversation
end
