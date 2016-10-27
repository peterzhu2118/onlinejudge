include SessionsHelper
Rails.application.routes.draw do


  root 'welcome#index'
  if (logged_in?)
  get '/login', to: redirect('/panel')
  else
  get '/login', to: 'sessions#new'
  end
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/panel', to: 'sessions#panel'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
