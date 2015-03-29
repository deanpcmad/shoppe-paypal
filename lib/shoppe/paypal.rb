require 'shoppe/paypal/version'
require 'shoppe/paypal/engine'

require 'shoppe/paypal/order_extensions'
require 'shoppe/paypal/payment_extensions'

module Shoppe
  module Paypal
    
    class << self
      
      def client_id
        Shoppe.settings.paypal_client_id
      end

      def client_secret
        Shoppe.settings.paypal_secret_id
      end

      def currency
        Shoppe.settings.paypal_currency
      end
      
      def setup
        Shoppe.add_settings_group :paypal, [:paypal_client_id, :paypal_secret_id, :currency]

        # Set the configuration
        require 'paypal-sdk-rest'
        
        include PayPal::SDK::REST

        PayPal::SDK.configure({
          mode:          (Rails.env.production? ? "live" : "sandbox"),
          client_id:     Shoppe.settings.paypal_client_id,
          client_secret: Shoppe.settings.paypal_secret_id
        })

        # When an order is accepted, attempt to capture the payment
        Shoppe::Order.before_acceptance do
          self.payments.where(confirmed: false, method: "PayPal").each do |payment|
            # begin
              payment.paypal_payment.execute(payer_id: payment.order.properties["paypal_payer_id"])
              payment.update_attribute(:confirmed, true)
            
            # rescue ::Stripe::CardError
              # raise Shoppe::Errors::PaymentDeclined, "Payment ##{payment.id} could not be captured by Stripe. Investigate with Stripe. Do not accept the order."
            # end
          end
        end
      end

    end
  end
end
