# PayPal Shoppe Module

**Currently in development**

This module helps with including PayPal within your Shoppe application. The information below explains how to get this module installed within your Rails application.

Add the gem to your Gemfile and run `bundle install`

`gem "shoppe-paypal"`


## Workflow

+ Start an order
+ Give the user the decision of payment
+ Create a PayPal payment
+ Redirect the user to PayPal using the previous URL
+ User logs in & accepts payment
+ Redirected to success URL and payment details are stored with the order
+ When the order is accepted, the payment will be executed/captured


## To Do

+ When rejecting an order, payment is not refunded