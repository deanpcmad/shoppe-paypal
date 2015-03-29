module Shoppe
  module Paypal
    module PaymentExtensions

      # Get the PayPal payment information from the API
      def paypal_payment
        return false unless self.method == "PayPal"

        @paypal_payment ||= PayPal::SDK::REST::Payment.find(self.reference)
      end

      # The PayPal transaction URL
      def transaction_url
        if Rails.env.production?
          "https://history.paypal.com/uk/cgi-bin/webscr?cmd=_history-details-from-hub&id=#{reference}"
        else
          "https://www.sandbox.paypal.com/uk/cgi-bin/webscr?cmd=_history-details-from-hub&id=#{reference}"
        end
      end

    end
  end
end