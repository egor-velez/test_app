# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :publisher
  has_many :shops_books_info

  validates :title, presence: true
end
