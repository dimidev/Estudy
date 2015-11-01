class Registration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Datatable

  field :grade, type: Float

  recursively_embeds_many
  belongs_to :student
  has_and_belongs_to_many :courses, inverse_of: nil

  accepts_nested_attributes_for :child_registrations, allow_destroy: true, reject_if: :all_blank
end
