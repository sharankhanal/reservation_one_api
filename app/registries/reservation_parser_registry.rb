# frozen_string_literal: true

#  class for module registry
class ReservationParserRegistry

  class << self
    # add registry
    REGISTRY = {
      partner_one: PartnerOne::ReservationParser,
      partner_two: PartnerTwo::ReservationParser
    }

    def find(partner)
      return unless partner

      REGISTRY[partner.to_sym]
    end
  end
end