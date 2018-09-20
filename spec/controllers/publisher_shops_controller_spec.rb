# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublisherShopsController, type: :controller do
  let(:book) { create :book }
  let(:shop) { create :shop }
  let(:book2) { create :book, publisher_id: book.publisher_id }
  let(:book3) { create :book, publisher_id: book.publisher_id }
  let(:book_another_publisher) { create :book }

  describe "GET #Show" do
    let!(:book_info) { create :shops_books_info, book_id: book.id, shop_id: shop.id }

    describe "Success" do
      let!(:book_info2) { create :shops_books_info, book_id: book2.id, shop_id: shop.id }
      let!(:book_info_other_publisher) { create :shops_books_info, shop_id: shop.id }
      let!(:book_info_other_publisher_and_shop) { create :shops_books_info, book_id: book_another_publisher.id }
      let!(:book_not_in_stock) { create :shops_books_info, book_id: book3.id, shop_id: shop.id, in_stock: 0 }
      let!(:book_info_max) { create :shops_books_info, book_id: book.id, sold: 1000 }
      let!(:book_info_min) { create :shops_books_info, book_id: book.id, sold: 1 }

      it "Returns Correct Values of Books Count" do
        get :show, params: { id: book.publisher_id }
        expect(find_shop(shop.id)['books_sold_count'].to_i).to eq(book_info.sold + book_info2.sold + book_not_in_stock.sold)
        expect(find_shop(shop.id)['books_in_stock'].count).to eq(2)
      end

      it "Returns Corrent Shops Count and Shops in Correct Order" do
        get :show, params: { id: book.publisher_id }
        expect(json_shops.count).to eq(3)
        expect(json_shops.first['id'].to_i).to eq(book_info_max.shop_id)
        expect(json_shops.last['id'].to_i).to eq(book_info_min.shop_id)
      end
    end

    describe "Errors" do
      it "Returns Errors" do
        get :show, params: { id: Publisher.last.id + 1 }
        expect(response.body).to include('errors')
      end
    end
  end
end

def json_shops
  JSON(response.body)['shops']
end

def find_shop(id)
  json_shops.select {|shop| shop['id'].to_i == id }.first
end
