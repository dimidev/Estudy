class Admin < User
  after_initialize :defaults

  belongs_to :department
  has_many :notices

  private
  def defaults
    self.role= :admin
  end
end
