# frozen_string_literal: true

class ShopBooksSellController < ApplicationController
  #/shop_books_sell/:id { :book_id, :number_of_copies }
  def update
    render json: sell_book
  end

  private

  def sell_book
    service = ShopBooksSellService.new(shop_id: params[:id], book_id: params[:book_id], number_of_copies: params[:number_of_copies])
    return service.result if service.call
    return { errors: service.errors }
  end

end
