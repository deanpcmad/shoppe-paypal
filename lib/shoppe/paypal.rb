require 'shoppe/paypal/version'
require 'shoppe/paypal/engine'

module Shoppe
  module Paypal
    
    class << self
      
      def api_username
        Shoppe.settings.paypal_api_username
      end
      
      def api_password
        Shoppe.settings.paypal_api_password
      end

      def api_signature
        Shoppe.settings.paypal_api_signature
      end
      
      def setup
        # Set the configuration which we would like
        Shoppe.add_settings_group :paypal, [:paypal_api_username, :paypal_api_password, :paypal_api_signature]
      end

    end
  end
end
