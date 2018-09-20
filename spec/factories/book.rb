# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    publisher
    title { Faker::Lorem.word }
  end
end
