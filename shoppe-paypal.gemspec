$:.push File.expand_path("../lib", __FILE__)

require "shoppe/paypal/version"

Gem::Specification.new do |s|
  s.name        = "shoppe-paypal"
  s.version     = Shoppe::Paypal::VERSION
  s.authors     = ["Dean Perry"]
  s.email       = ["dean@voupe.com"]
  s.homepage    = "http://voupe.com"
  s.summary     = "A PayPal payment module for Shoppe."
  s.description = "A Shoppe module to assist with the integration of PayPal."

  s.files = Dir["{lib,vendor}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "shoppe", "> 1", "< 2"
  s.add_dependency "paypal-sdk-rest"
end
