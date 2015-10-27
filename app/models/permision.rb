class Permision
  include Mongoid::Document

  embedded_in :user
end
