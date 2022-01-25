module Partner
  class AlphaCompanyForm < Normalizer
    attr_accessor :reservation_code, :start_date, :end_date, :adults, :children,
                  :guest, :nights, :guests, :infants, :status, :currency, :payout_price,
                  :security_price, :total_price, :guest_first_name, :guest_last_name,
                  :guest_phone, :guest_email
    validates_presence_of :reservation_code, :start_date, :end_date, :adults,
            :children, :infants, :status, :currency, :payout_price, :security_price, :total_price,
            :guest_first_name, :guest_last_name, :guest_phone, :guest_email

    def submit
      guest = parse_guest_model
      guest.save!

      reservation = parse_reservation_model(guest.id)
      reservation.save!

      { reservation: reservation, guest: guest }
    end

    private

    def parse_guest_model
      guest = current_guest

      guest.first_name = guest_first_name
      guest.last_name = guest_last_name
      guest.email = guest_email
      guest.add_phones!([guest_phone])

      guest
    end

    def parse_reservation_model(guest_id)
      reservation = current_reservation

      reservation.code = reservation_code
      reservation.guest_id = guest_id
      reservation.add_phones!([guest_phone])
      reservation.start_date = start_date
      reservation.end_date = end_date
      reservation.num_of_adults = adults
      reservation.num_of_children = children
      reservation.num_of_infants = infants
      reservation.status = status
      reservation.currency = currency
      reservation.payout_price = payout_price
      reservation.security_price = security_price
      reservation.total_price = total_price

      reservation
    end

    def current_guest
      @current_guest ||= Guest.find_by(email: guest_email) || Guest.new
    end

    def current_reservation
      @current_reservation ||= Reservation.find_by(code: reservation_code) || Reservation.new
    end
  end
end