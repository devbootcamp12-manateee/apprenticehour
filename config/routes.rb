Manatee::Application.routes.draw do
  match 'auth/:provider/callback', :to => 'sessions#create'
  match 'auth/failure', :to => redirect('/')
  match 'signout', :to => 'sessions#destroy', as: 'signout'
  match 'about', :to => 'static_pages#about'
  match 'howitworks', :to => 'static_pages#howitworks'

  root :to => 'meetings#index'

  resources :meetings, :only => [:index, :create, :update]
  resources :users, :only => [:show, :edit, :update]
end
