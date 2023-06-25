# frozen_string_literal: true

# parser class for reservation payload for v1
module PartnerOne
  class ReservationParser < BaseParser
    def parse
      unless payload.present?
        add_error('Payload is empty or null')
        return
      end

      @parsed_payload =
        {
          reservation_attributes: {
            code:             payload.dig(:reservation_code),
            start_date:       payload.dig(:start_date),
            end_date:         payload.dig(:end_date),
            nights:           payload.dig(:nights),
            guests:           payload.dig(:guests),
            adults:           payload.dig(:adults),
            children:         payload.dig(:children),
            infants:          payload.dig(:infants),
            status:           payload.dig(:status),
            currency:         payload.dig(:currency),
            payout_price:     payload.dig(:payout_price),
            security_price:   payload.dig(:security_price),
            total_price:      payload.dig(:total_price),
          },
          guest_attributes: {
            first_name:       payload.dig(:guest, :first_name),
            last_name:        payload.dig(:guest, :last_name),
            phone:            payload.dig(:guest, :phone),
            email:            payload.dig(:guest, :email)
          }
        }
    rescue StandardError => e
      log_error(e.inspect)
      add_error('could not parse the payload')
    end
  end
end

