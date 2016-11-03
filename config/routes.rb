Rails.application.routes.draw do

  devise_for :users
  root 'welcome#index'
  get '/login', to: redirect('/users/sign_in')
  get '/panel', to: 'sessions#panel'
  get '/contest/:contest_id', to: 'contests#main'
  get '/problem/:contest_id/:problem_id', to: 'problems#main'
  get '/problem/:contest_id/:problem_id/submit', to: 'problems#submit'
  get '/submission', to: 'sessions#submission'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
