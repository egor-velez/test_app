# frozen_string_literal: true

class ShopsBooksInfo < ApplicationRecord
  belongs_to :shop
  belongs_to :book
end
