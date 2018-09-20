# frozen_string_literal: true

class PublisherShopsController < ApplicationController
  #/publisher_shops/:id
  def show
    render json: shops #, status: :unprocessable_entity
  end

  private

  def shops
    service = PublisherShopsService.new(publisher_id: params[:id])
    return service.result if service.call
    return { errors: service.errors }
  end

end
