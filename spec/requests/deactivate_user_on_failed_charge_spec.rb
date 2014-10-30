require 'spec_helper' 

describe 'Deactivate user on failed charge' do
  let(:event_data) do 
    {
      "id"=> "evt_14t8pdAQtNZoyYMJ7ThBBnCs",
      "created"=> 1414636717,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_14t8pdAQtNZoyYMJRjOaz6oC",
          "object"=> "charge",
          "created"=> 1414636717,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_14t8oYAQtNZoyYMJuJWnNrCE",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 11,
            "exp_year"=> 2019,
            "fingerprint"=> "2OHQZhIaz2LAFdam",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil, 
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,  
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "dynamic_last4"=> nil,
            "customer"=> "cus_52VyWqbCqsXdHb"
          },
          "captured"=> false,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_14t8pdAQtNZoyYMJRjOaz6oC/refunds",
            "data"=> []
          },
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_52VyWqbCqsXdHb",
          "invoice"=> nil,
          "description"=> "paymaent to fail",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> nil,
          "fraud_details"=> {
            "stripe_report"=> nil,
            "user_report"=> nil
          },
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_53FK4A74kH6Bvk"
    }
  end

  it "deactivates a user with the web hook data from stripe for a charge failed", :vcr do
    bob = Fabricate(:user, customer_token: "cus_52VyWqbCqsXdHb")
    post "/stripe_events", event_data
    expect(bob.reload).not_to be_active
  end
end