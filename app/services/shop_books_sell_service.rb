# frozen_string_literal: true

class ShopBooksSellService
  include ActiveModel::Model
  attr_accessor :shop_id, :book_id, :number_of_copies, :result
  validate :shop_should_be_present, :book_should_be_in_stock
  validates_presence_of :number_of_copies

  def call
    return false unless valid?
    self.result = json_result
  end

  private

  def sell_book
    shop_book_info.sell(number_of_copies)
    shop_book_info.in_stock
  end

  def json_result
    { left_in_stock: sell_book }
  end

  def book_in_stock?
    in_stock = shop_book_info.try(:in_stock)
    in_stock.to_i >= number_of_copies.to_i
  end

  def shop_book_info
    @shop_book_info ||= ShopsBooksInfo.find_by(shop_id: shop_id, book_id: book_id)
  end

  def book_should_be_in_stock
    return if book_id.present? && Book.find_by(id: book_id) && book_in_stock?
    errors.add(:base, "Book not present or not in stock")
  end

  def shop_should_be_present
    return if shop_id.present? && Shop.find_by(id: shop_id)
    errors.add(:base, "Shop should be present")
  end

end
