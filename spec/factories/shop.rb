# frozen_string_literal: true

FactoryBot.define do
  factory :shop do
    name { Faker::Lorem.word }
  end
end
