# frozen_string_literal: true

class ShopsBooksInfo < ApplicationRecord
  belongs_to :shop
  belongs_to :book

  validates :in_stock, numericality: { only_integer: true, greater_than_or_equal_to: 0  }

  def sell(number_of_copies)
    self.in_stock -= number_of_copies.to_i
    self.sold += number_of_copies.to_i
    save
  end
end
