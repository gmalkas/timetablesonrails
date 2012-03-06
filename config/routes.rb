Timetablesonrails::Application.routes.draw do
  post '/' => 'home#sign_in', as: 'sign_in'
  get '/deconnexion' => 'home#sign_out', as: 'sign_out'

  scope(:path_names => { :new => "nouveau", :edit => "modifier" }) do
    resources :school_years, :path => 'annees-scolaires', :constraints => {:id => /[0-9]{4}/} do
      member do
        post 'activer' => 'school_years#activate', as: 'activate'
        post 'desactiver' => 'school_years#disable', as: 'disable'
        post 'archiver' => 'school_years#archive', as: 'archive'
        post 'desarchiver' => 'school_years#remove_from_archive', as: 'remove_from_archive'
      end
    end
  end

  root :to => 'home#index'
end
