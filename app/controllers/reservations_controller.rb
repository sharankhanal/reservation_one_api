# frozen_string_literal: true

# controller class for reservation
class ReservationsController < ApplicationController
  before_action :check_authorization
  # method to create or update reservation
  def create_or_update
    service = ManageReservationService.new(params: params)

    if service.call
      render json: { success: true }, status: :ok
      return
    end

    render json: service.error, status: :unprocessable_entity
  end

  private

  def check_authorization
    # TODO, impelementation of authorisation
    true
  end
end
