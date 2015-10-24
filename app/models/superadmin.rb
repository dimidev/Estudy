class Superadmin < User
  after_initialize :defaults

  belongs_to :institution

  private
  def defaults
    self.role= :superadmin
  end
end
