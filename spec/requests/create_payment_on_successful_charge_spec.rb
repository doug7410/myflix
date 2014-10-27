require 'spec_helper'

describe "Create payment on successful charge"  do
  let(:event_data) do
    {
      "id"=> "evt_14rxyWAQtNZoyYMJUgDdNISI",
      "created"=> 1414356656,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_14rxyWAQtNZoyYMJYtqLJWpo",
          "object"=> "charge",
          "created"=> 1414356656,
          "livemode"=> false,
          "paid"=> true,
          "ammount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_14rxyUAQtNZoyYMJRtsclxqZ",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 10,
            "exp_year"=> 2016,
            "fingerprint"=> "9jgXysEZroh2shiR",
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
            "customer"=> "cus_5222Vc3jpmZtoi"
          },
          "captured"=> true,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_14rxyWAQtNZoyYMJYtqLJWpo/refunds",
            "data"=> []
          },
          "balance_transaction"=> "txn_14rxyWAQtNZoyYMJJgoucAWs",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_5222Vc3jpmZtoi",
          "invoice"=> "in_14rxyWAQtNZoyYMJG7qqHR7B",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> nil,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5222h4oLuYmAAX"
    }
  end

  it "[creates a payment with the webhook from stripe for charge succeded]", :vcr do
    post "/stripe_events", {
      "id"=> "evt_14rxyWAQtNZoyYMJUgDdNISI",
      "created"=> 1414356656,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_14rxyWAQtNZoyYMJYtqLJWpo",
          "object"=> "charge",
          "created"=> 1414356656,
          "livemode"=> false,
          "paid"=> true,
          "ammount_in_cents"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_14rxyUAQtNZoyYMJRtsclxqZ",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 10,
            "exp_year"=> 2016,
            "fingerprint"=> "9jgXysEZroh2shiR",
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
            "customer"=> "cus_5222Vc3jpmZtoi"
          },
          "captured"=> true,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_14rxyWAQtNZoyYMJYtqLJWpo/refunds",
            "data"=> []
          },
          "balance_transaction"=> "txn_14rxyWAQtNZoyYMJJgoucAWs",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_5222Vc3jpmZtoi",
          "invoice"=> "in_14rxyWAQtNZoyYMJG7qqHR7B",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> nil,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5222h4oLuYmAAX"
    }
    expect(Payment.count).to eq(1)
  end
end