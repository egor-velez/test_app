# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopBooksSellController, type: :controller do
  let(:book) { create :book }
  let(:shop) { create :shop }
  let!(:book_info) { create :shops_books_info, book_id: book.id, shop_id: shop.id }

  describe "PUT #Update" do
    describe "Success" do
      it "Change Books in Stock Count" do
        expect do
          put :update, params: { id: shop.id, book_id: book.id, number_of_copies: 3 }
          book_info.reload
        end.to change { book_info.in_stock }.by (-3)
      end

      it "Change Books Sold Count" do
        expect do
          put :update, params: { id: shop.id, book_id: book.id, number_of_copies: 3 }
          book_info.reload
        end.to change { book_info.sold }.by (3)
      end

      it "Return Books in Stock Count" do
        put :update, params: { id: shop.id, book_id: book.id, number_of_copies: 5 }
        book_info.reload
        expect(json_body['left_in_stock'].to_i).to eq(book_info.in_stock)
      end
    end

    describe "Errors" do
      let(:book2) { create :book }
      let(:shop2) { create :shop }
      let!(:book_info2) { create :shops_books_info, book_id: book2.id, shop_id: shop2.id, in_stock: 0 }

      it "Return Book Error" do
        put :update, params: { id: shop.id, book_id: Book.last.id + 1, number_of_copies: 5 }
        expect(response.body).to include('Book not present or not in stock')
      end

      it "Return Book Error in Stock" do
        put :update, params: { id: shop2.id, book_id: book2.id, number_of_copies: 5 }
        expect(response.body).to include('Book not present or not in stock')
      end

      it "Return Shop Error" do
        put :update, params: { id: Shop.last.id + 1, book_id: book2.id, number_of_copies: 5 }
        expect(response.body).to include('Shop should be present')
      end

      it "Return Number of Copies Error" do
        put :update, params: { id: shop.id, book_id: book.id }
        expect(response.body).to include("can't be blank")
      end
    end
  end
end

def json_body
  JSON(response.body)
end


