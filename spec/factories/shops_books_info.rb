# frozen_string_literal: true

FactoryBot.define do
  factory :shops_books_info do
    book
    shop
    sold { Faker::Number.number(2) }
    in_stock { Faker::Number.number(2) }
  end
end
