Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :publisher_shops, only: :show
  resources :shop_books_sell, only: :update
end
