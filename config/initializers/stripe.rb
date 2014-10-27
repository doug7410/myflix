Stripe.api_key = ENV["STRIPE_API_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    Payment.create
  end
end