require 'shoppe/paypal/version'
require 'shoppe/paypal/engine'

require 'paypal-sdk-rest'

require 'shoppe/paypal/order_extensions'
require 'shoppe/paypal/payment_extensions'

module Shoppe
  module Paypal
    
    class << self
      
      def client_id
        Shoppe.settings.paypal_client_id
      end

      def client_secret
        Shoppe.settings.paypal_client_secret
      end

      def currency
        Shoppe.settings.paypal_currency
      end
      
      def setup
        # Set the configuration
        Shoppe.add_settings_group :paypal, [:paypal_client_id, :paypal_client_secret, :paypal_currency]

        # When an order is accepted, attempt to capture/execute the payment
        Shoppe::Order.before_acceptance do
          self.payments.where(confirmed: false, method: "PayPal").each do |payment|
            begin
              payment.paypal_payment.execute(payer_id: payment.order.properties["paypal_payer_id"])
              payment.update_attribute(:confirmed, true)
            rescue
              raise Shoppe::Errors::PaymentDeclined, "Payment ##{payment.id} could not be captured by PayPal. Investigate with PayPal. Do not accept the order."
            end
          end
        end
      end

      # Setup the PayPal configuration
      def setup_paypal
        include PayPal::SDK::REST

        PayPal::SDK.configure({
          mode:          (Rails.env.production? ? "live" : "sandbox"),
          client_id:     client_id,
          client_secret: client_secret
        })
      end

    end
  end
end
