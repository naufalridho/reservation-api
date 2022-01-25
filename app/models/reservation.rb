class Reservation < ActiveRecord::Base
  belongs_to :guest, class_name: 'Guest'

  validates :code, :uniqueness => true

  def add_phone!(new_phones)
    phones = guest_phone ? JSON.parse(guest_phone) : []
    phones.concat(new_phones)
    self.guest_phone = phones.uniq
  end
end
