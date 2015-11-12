Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'user/registrations' }
  resources :user_stocks, except: [:edit, :update, :show]

  root to: 'welcome#index'

  get 'my_portfolio',  to: 'users#my_portfolio'
  get 'search_stocks', to: 'stocks#search'
  get 'my_friends',    to: 'users#my_friends'
end
