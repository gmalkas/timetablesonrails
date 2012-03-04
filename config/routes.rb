Timetablesonrails::Application.routes.draw do
  get 'administration' => 'administration#dashboard', as: 'dashboard'
  get 'home/index'
  get 'courses' => 'school_years#index'

  root :to => 'home#index'
end
