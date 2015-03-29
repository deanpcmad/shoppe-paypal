# PayPal Shoppe Module

This module helps with including PayPal within your Shoppe application.
The information below explains how to get this module installed within your Rails application.

## Installing

Add the gem to your Gemfile and run `bundle install`

`gem "shoppe-paypal"`

For the latest up to date documentation, please see the [Shoppe tutorial page](http://tryshoppe.com/docs/payment-gateways/paypal).

## Workflow

+ Start an order
+ Give the user the decision of payment
+ Create a PayPal payment
+ Redirect the user to PayPal using the previous URL
+ User logs in & accepts payment
+ Redirected to success URL and payment details are stored with the order
+ Complete order
+ When the order is accepted in the Shoppe admin, the payment will be executed/captured

## To Do

+ Tests!
+ When rejecting an order, payment is not refunded