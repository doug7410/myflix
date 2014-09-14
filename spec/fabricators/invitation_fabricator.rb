Fabricator(:invitation) do
  recipient_name {Faker::Lorem.words(2).join(" ")}
  recipient_email {Faker::Internet.email}
  message {Faker::Lorem.sentence.first}
end