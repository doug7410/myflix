Stripe.api_key = ENV["STRIPE_API_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.where(customer_token: event.data.object.customer).first
    amount = event.data.object.amount
    reference_id = event.data.object.id
    Payment.create(user: user, ammount_in_cents: amount, reference_id: reference_id)
  end
end