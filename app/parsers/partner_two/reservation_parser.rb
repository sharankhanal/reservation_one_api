# frozen_string_literal: true

# parser class for reservation payload for v1
module PartnerTwo
  class ReservationParser < BaseParser
    def parse
      unless payload.present?
        add_error('Payload is empty or null')
        return
      end
      
      @parsed_payload =
        {
          reservation_attributes: {
            code:             payload.dig(:reservation, :code),
            start_date:       payload.dig(:reservation, :start_date),
            end_date:         payload.dig(:reservation, :end_date),
            nights:           payload.dig(:reservation, :nights),
            guests:           payload.dig(:reservation, :number_of_guests),
            adults:           payload.dig(:reservation, :guest_details, :number_of_adults),
            children:         payload.dig(:reservation, :guest_details, :number_of_children),
            infants:          payload.dig(:reservation, :guest_details, :number_of_infants),
            status:           payload.dig(:reservation, :status_type),
            currency:         payload.dig(:reservation, :host_currency),
            payout_price:     payload.dig(:reservation, :expected_payout_amount),
            security_price:   payload.dig(:reservation, :listing_security_price_accurate),
            total_price:      payload.dig(:reservation, :total_paid_amount_accurate),
          },
          guest_attributes: {
            first_name:       payload.dig(:reservation, :guest_first_name),
            last_name:        payload.dig(:reservation, :guest_last_name),
            phone:            payload.dig(:reservation, :guest_phone_numbers)&.join(', '),
            email:            payload.dig(:reservation, :guest_email)
          }
        }
    rescue StandardError => e
      log_error(e.inspect)
      add_error('could not parse the payload')
    end
  end
end
