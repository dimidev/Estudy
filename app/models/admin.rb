class Admin < User
  after_initialize :defaults

  belongs_to :department

  private
  def defaults
    self.role= :admin
  end
end
