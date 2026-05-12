FactoryBot.define do
  factory :locality do
    sequence(:name) { |n| "Test Locality #{n}" }
    city { "Chicago" }
    state { "IL" }
  end
end
