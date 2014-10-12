module Shoppe
  module Paypal
    class Engine < Rails::Engine
      
      initializer "shoppe.paypal.initializer" do
        Shoppe::Paypal.setup
      end
      
    end
  end
end
