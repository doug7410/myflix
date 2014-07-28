Fabricator(:user) do
  email {Faker::Internet.email}
  password {Faker::Lorem.words(3).join}
  full_name {Faker::Name.name}
end