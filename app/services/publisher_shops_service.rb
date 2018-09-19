# frozen_string_literal: true

class PublisherShopsService
  include ActiveModel::Model
  attr_accessor :publisher_id, :result
  validate :publisher_should_be_present

  def call
    return false unless valid?
    self.result = json_result
  end

  private

  def base_query
    Shop.joins("INNER JOIN shops_books_infos ON shops.id = shops_books_infos.shop_id AND shops_books_infos.sold > 0")
  end

  def shops
    @shops ||= base_query.joins("INNER JOIN books ON books.id = shops_books_infos.book_id AND books.publisher_id = #{publisher_id} AND shops_books_infos.in_stock > 0")
                         .select(selected_fields.join(', '))
  end

  def selected_fields
    [
      'shops.*',
      'books.id as book_id',
      'books.title as book_title',
      'shops_books_infos.in_stock as book_count_in_stock'
    ]
  end

  def shop_sold
    @shop_sold ||= base_query.joins("INNER JOIN books ON books.id = shops_books_infos.book_id AND books.publisher_id = #{publisher_id}")
                             .group('shops.id')
                             .select('shops.id, sum(shops_books_infos.sold) as sold_all')
                             .order('sold_all desc')
  end

  def grouped_result
    @grouped_result ||= shops.group_by { |x| x.id }
  end

  def json_result
    json_result = { shops: [] }
    shop_sold.each do |order_sold|
      json_result[:shops] << json_shop(grouped_result[order_sold.id], order_sold.sold_all)
    end

    json_result
  end

  def json_shop(shop, sold)
    {
      id: shop[0].id,
      name: shop[0].name,
      books_sold_count: sold,
      books_in_stock: json_books(shop)
    }
  end

  def json_books(shop)
    shop.map{|x| { id: x.id, title: x.book_title, copies_in_stock: x.book_count_in_stock } }
  end

  def publisher_should_be_present
    return if publisher_id.present? && Publisher.find_by(id: publisher_id)
    errors.add(:base, "Publisher must be present")
  end
end
