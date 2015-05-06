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
          Shoppe::Paypal.setup_paypal

          self.payments.where(confirmed: false, method: "PayPal").each do |payment|
            begin
              payment.paypal_payment.execute(payer_id: payment.order.properties["paypal_payer_id"])

              transaction = payment.paypal_payment.transactions.first.related_resources.first.sale.id

              payment.update_attribute(:confirmed, true)
              payment.update_attribute(:reference, transaction)
            rescue
              raise Shoppe::Errors::PaymentDeclined, "Payment ##{payment.id} could not be captured by PayPal. Investigate with PayPal. Do not accept the order."
            end
          end
        end

        # Refund the PayPal transaction
        Shoppe::Payment.before_refund do
          if self.method == "PayPal"
            Shoppe::Paypal.setup_paypal

            begin
              @sale = PayPal::SDK::REST::Sale.find(self.reference)
              @refund  = @sale.refund({
                :amount => {
                  :currency => Shoppe::Paypal.currency,
                  :total => "#{'%.2f' % self.refundable_amount}"}
              })
                
              # Check refund status
              if @refund.success?
                true
              else
                raise Shoppe::Errors::RefundFailed, message: "Unable to Refund" 
                logger.error "Unable to Refund"
                logger.error @refund.error.inspect
              end
            rescue
              raise Shoppe::Errors::RefundFailed, message: "PayPal Sale '#{self.reference}' Not Found" 

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
