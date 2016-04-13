Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'home#index'
  get '/search', to: 'home#search'
  post '/search_hotel/:hotel_id', to: 'home#search_hotel', as: :search_hotel
  get '/check', to: 'home#check'
  get '/load_more', to: 'home#load_more'
  get '/hotel/:id', to: 'home#hotel', as: :hotel
  get '/hotel/:id/check_tours', to: 'home#check_tours', as: :check_tours
  get '/hotel/:id/load_more_tours', to: 'home#load_more_tours', as: :load_more_tours
  get '/blog', to: 'blogs#index'
  get '/blog/:id', to: 'blogs#show'
  get '/blog/theme/:t_id', to: 'blogs#theme_show'
  get '/about', to: 'blogs#about'
  get '/operators', to: 'operators#index'
  get '/operator/:id', to: 'operators#show'
  get '/countries', to: 'countries#index'
  get '/countries/category/:id', to: 'countries#show_region'
  get '/ajax', to: 'home#ajax'
  get '/form', to: 'blogs#form'
end
