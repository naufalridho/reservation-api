class Guest < ActiveRecord::Base
  has_many :reservations

  validates :email, :uniqueness => true

  def add_phones!(new_phones)
    phones = phone ? JSON.parse(phone) : []
    phones.concat(new_phones)
    self.phone = phones.uniq
  end
end