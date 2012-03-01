Timetablesonrails::Application.routes.draw do
  get 'administration' => 'administration#dashboard', as: 'dashboard'
  post '/' => 'home#sign_in', as: 'sign_in'

  root :to => 'home#index'
end
