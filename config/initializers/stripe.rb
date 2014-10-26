Stripe.api_key = ENV["STRIPE_API_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeded' do |event|
    binding.pry
    Payment.create
  end
end