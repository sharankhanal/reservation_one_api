# frozen_string_literal: true

# Reservation Service class
class ManageReservationService < BaseService
  attr_reader :params
  attr_accessor :parsed_params

  def initialize(**kwargs)
    super

    @params = kwargs[:params]
  end
  
  def call
   do_call
  end

  private

  def do_call
    # Check if payload is provided as params
    unless params.present?
      add_error('payload is empty or not provided')
      return false
    end

    # Determine partner using service
    partner_service = DeterminePartnerService.new(payload: params)
    partner_service.call

    unless partner_service.successful?
      add_error(partner_service.error_message)
      return false
    end

    partner = partner_service.partner

    # Check if partner is registered for parser
    registered_parser = ReservationParserRegistry.find(partner)

    unless registered_parser.present?
      add_error("Parser not found in the registry for partner: #{partner}")
      return false
    end

    # parse the payload after determining the parser
    parser = registered_parser.new(params)
    parser.parse

    unless parser.successful?
      add_error(parser.error_message)
      return false
    end

    # finally save reservation
    save_reservation(parser.parsed_payload)
  end

  def save_reservation(params)
    guest_email = params.dig(:guest_attributes, :email)
    reservation_code = params.dig(:reservation_attributes, :code)

    reservation = Reservation.find_or_create_by(code: reservation_code)
    reservation.assign_attributes(params.dig(:reservation_attributes))

    guest = Guest.find_or_create_by(email: guest_email)
    guest.assign_attributes(params.dig(:guest_attributes))

    guest.reservations << reservation

    errors = []

    # run validation and generate model errors for guest and reservation
    errors << guest.errors.map { |e| "guest #{e.attribute} #{e.message}" } unless guest.valid?
    errors << reservation.errors.map { |e| "reservation #{e.attribute} #{e.message}" } unless reservation.valid?

    unless errors.blank?
      add_error("could not save reservation #{reservation_code} for #{guest_email}. Error ->: #{errors.join(', ')}")
      return false
    end

    # save guest and associated reservation
    guest.save(validate: false)
  end
end
