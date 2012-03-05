Timetablesonrails::Application.routes.draw do
  get 'administration' => 'administration#dashboard', as: 'dashboard'
  post '/' => 'home#sign_in', as: 'sign_in'
  get '/deconnexion' => 'home#sign_out', as: 'sign_out'

  resources :school_years, :path => 'annees-scolaires'

  root :to => 'home#index'
end
