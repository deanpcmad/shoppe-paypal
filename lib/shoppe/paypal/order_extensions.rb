module Shoppe
  module Paypal
    module OrderExtensions
      
      def redirect_to_paypal(return_url, cancel_url)
        # self.properties['stripe_customer_token'] = token

        # begin
          # charge = ::Stripe::Charge.create({:customer => self.properties['stripe_customer_token'], :amount => (self.total * BigDecimal(100)).round, :currency => Shoppe.settings.stripe_currency, :capture => false}, Shoppe.settings.stripe_api_key)

          @payment = PayPal::SDK::REST::Payment.new({
            :intent => "sale",
            :payer => {
              :payment_method => "paypal" },
            :redirect_urls => {
              :return_url => return_url,
              :cancel_url => cancel_url },
            :transactions => [ {
              :amount => {
                :total => '%.2f' % self.total,
                :currency => Shoppe::Paypal.currency },
              :description => "Order #{self.number}" } ] } )

          if @payment.create
            redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
          elsif @payment.error
            raise Shoppe::Errors::PaymentDeclined, "There was an error contacting the payment processor"
          end

      end

      def accept_paypal_payment(payment_id, token, payer_id)

        self.payments.create(amount: self.total, method: "PayPal", reference: payment_id, refundable: true, confirmed: false)

        self.properties["paypal_payment_id"] = payment_id
        self.properties["paypal_payment_token"] = token
        self.properties["paypal_payer_id"] = payer_id
        self.save

        true
      end

    end
  end
end
