Fabricator(:review) do
  body {Faker::Lorem.paragraph }
  rating { (1..5).to_a.sample }
  user
  video
end