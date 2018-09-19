# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :shops_books_info
  validates :name, presence: true
end
