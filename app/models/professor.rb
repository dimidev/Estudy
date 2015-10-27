class Professor < User
  after_initialize :defaults

  def defaults
    self.role = :professor
  end

  has_and_belongs_to_many :departments, inverse_of: nil
end
