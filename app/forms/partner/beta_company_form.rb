module Partner
  class BetaCompanyForm < Normalizer
    attr_accessor :reservation, :reservation_code, :reservation_start_date, :reservation_end_date,
                  :reservation_expected_payout_amount, :reservation_guest_details, :guest_details_localized_description,
                  :guest_details_number_of_adults, :guest_details_number_of_children, :guest_details_number_of_infants,
                  :reservation_guest_email, :reservation_guest_first_name, :reservation_guest_last_name,
                  :reservation_guest_phone_numbers, :reservation_listing_security_price_accurate,
                  :reservation_host_currency, :reservation_nights, :reservation_number_of_guests,
                  :reservation_status_type, :reservation_total_paid_amount_accurate

    validates_presence_of :reservation, :reservation_code, :reservation_start_date, :reservation_end_date,
                          :reservation_expected_payout_amount, :reservation_guest_details, :guest_details_number_of_adults,
                          :guest_details_number_of_children, :guest_details_number_of_infants,
                          :reservation_guest_email, :reservation_guest_first_name, :reservation_guest_last_name,
                          :reservation_guest_phone_numbers, :reservation_listing_security_price_accurate,
                          :reservation_host_currency, :reservation_status_type, :reservation_total_paid_amount_accurate

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

      guest.first_name = reservation_guest_first_name
      guest.last_name = reservation_guest_last_name
      guest.email = reservation_guest_email
      guest.phone = reservation_guest_phone_numbers

      guest
    end

    def parse_reservation_model(guest_id)
      reservation = current_reservation

      reservation.code = reservation_code
      reservation.guest_id = guest_id
      reservation.add_phone!(reservation_guest_phone_numbers)
      reservation.start_date = reservation_start_date
      reservation.end_date = reservation_end_date
      reservation.num_of_adults = guest_details_number_of_adults
      reservation.num_of_children = guest_details_number_of_children
      reservation.num_of_infants = guest_details_number_of_infants
      reservation.status = reservation_status_type
      reservation.currency = reservation_host_currency
      reservation.payout_price = reservation_expected_payout_amount
      reservation.security_price = reservation_listing_security_price_accurate
      reservation.total_price = reservation_total_paid_amount_accurate

      reservation
    end

    def current_guest
      @current_guest ||= Guest.find_by(email: reservation_guest_email) || Guest.new
    end

    def current_reservation
      @current_reservation ||= Reservation.find_by(code: reservation_code) || Reservation.new
    end
  end
end