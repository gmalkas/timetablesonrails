Timetablesonrails::Application.routes.draw do
  post '/' => 'session#sign_in!', as: 'sign_in'
  get '/deconnexion' => 'session#sign_out', as: 'sign_out'

  get '/annee-active' => 'courses#index', as: 'active_school_year'
  post '/annee-active/choisir-responsable/:id/:candidate' => 'courses#choose_course_manager', as: 'choose_course_manager'
  post '/annee-active/supprimer-candidat/:id/:candidate' => 'courses#dismiss_candidate', as: 'dismiss_candidate'
  post '/annee-active/postuler/:id' => 'courses#apply', as: 'apply_to_course_management' 
  post '/annee-active/retirer-candidature/:id' => 'courses#withdraw', as: 'withdraw_course_management_application'

  scope(:path_names => { :new => "nouveau", :edit => "modifier" }) do
    resources :school_years, :path => 'annees-scolaires', :constraints => {:id => /[0-9]{4}/} do
      member do
        post 'activer' => 'school_years#activate', as: 'activate'
        post 'desactiver' => 'school_years#disable', as: 'disable'
        post 'archiver' => 'school_years#archive', as: 'archive'
        post 'desarchiver' => 'school_years#restore', as: 'restore'
      end
    end
    resources :teachers, path: "enseignants"
    resources :courses, path: 'unites-enseignement' do
      member do
        post 'demissionner' => 'courses#resign', as: 'resign_as_manager'
      end
      resources :activities, path: 'activites' do
        member do
          post 'choisir-candidat/:candidate' => 'activities#choose_activity_teacher', as: 'choose_activity_teacher'
          post 'postuler' => 'activities#apply', as: 'apply_to_activity'
          post 'retirer-candidature' => 'activities#withdraw', as: 'withdraw_activity_teaching_application'
          post 'retirer-enseignant/:teacher' => 'activities#dismiss_teacher', as: 'dismiss_activity_teacher'
          post 'supprimer-candidat/:candidate' => 'activities#dismiss_candidate', as: 'dismiss_activity_candidate'
          post 'demissionner' => 'activities#resign', as: 'resign_as_teacher'
        end
      end
    end
  end

  root :to => 'home#dashboard'
end
