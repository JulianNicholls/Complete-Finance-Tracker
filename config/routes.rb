Rails.application.routes.draw do
  devise_for :users

  root to: 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stocks', to: 'stocks#search'
end
