Timetablesonrails::Application.routes.draw do
  get 'administration' => 'administration#dashboard', as: 'dashboard'
  get 'home/index'

  root :to => 'home#index'
end
