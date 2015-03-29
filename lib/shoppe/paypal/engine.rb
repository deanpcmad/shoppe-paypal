module Shoppe
  module Paypal
    class Engine < Rails::Engine
      
      initializer "shoppe.paypal.initializer" do
        Shoppe::Paypal.setup
      end

      config.to_prepare do
        Shoppe::Order.send :include, Shoppe::Paypal::OrderExtensions
        Shoppe::Payment.send :include, Shoppe::Paypal::PaymentExtensions
      end
      
    end
  end
end
