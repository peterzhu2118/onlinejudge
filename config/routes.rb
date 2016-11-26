Rails.application.routes.draw do
  #resources :submissions, only: [:submit, :create]
 

  devise_for :users
  root 'welcome#index'
  get '/login', to: redirect('/users/sign_in')
  get '/panel', to: 'sessions#panel'
  get '/contest/:contest_id', to: 'contests#main'
  get '/problem/:contest_id/:problem_id', to: 'problems#main'
  get '/problem/:contest_id/:problem_id/submit', to: 'problems#submit'
  get '/submission', to: 'sessions#submission'
  post '/problem/:contest_id/:problem_id/submit', to: 'problems#upload'
  
  # Admin stuff
  get '/admin/submission', to: 'admin#all_submissions'
  get '/admin/submission/:id', to: 'admin#submission'
  get '/admin/user', to: 'admin#all_users'
  get '/admin/user/view/:id', to: 'admin#user'
  delete '/admin/user/view/:id', to: 'admin#delete_user'
  patch '/admin/user/view/:id', to: 'admin#update_user'
  get '/admin/user/new', to: 'admin#new_user'
  post '/admin/user/new', to: 'admin#create_user'
  
  resources :users, only: [:index, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
