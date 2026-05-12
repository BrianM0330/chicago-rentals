FactoryBot.define do
  factory :pin do
    association :user
    association :locality

    kind { "rent" }
    latitude { 41.8781 }
    longitude { -87.6298 }
    rent_cents { 180_000 }
    reported_on { Date.current }
  end
end
