Timetablesonrails::Application.routes.draw do
  get 'administration' => 'administration#dashboard', as: 'dashboard'
  post '/' => 'home#sign_in', as: 'sign_in'
  get '/deconnexion' => 'home#sign_out', as: 'sign_out'

  root :to => 'home#index'
end
