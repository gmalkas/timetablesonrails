Timetablesonrails::Application.routes.draw do
  post '/' => 'session#sign_in!', as: 'sign_in'
  get '/deconnexion' => 'session#sign_out', as: 'sign_out'

  scope(:path_names => { :new => "nouveau", :edit => "modifier" }) do
    resources :school_years, :path => 'annees-scolaires' do

      member do
        post 'activer' => 'school_years#activate', as: 'activate'
        post 'desactiver' => 'school_years#disable', as: 'disable'
        post 'archiver' => 'school_years#archive', as: 'archive'
        post 'desarchiver' => 'school_years#restore', as: 'restore'

      end

        resources :courses, path: 'ec' do
          member do
            post 'postuler' => 'courses#apply', as: 'apply_to_course_management' 
            post 'retirer-candidature' => 'courses#withdraw', as: 'withdraw_course_management_application'
            post 'demissionner' => 'courses#resign', as: 'resign_as_manager'

            get 'choisir-responsable' => 'courses#pick_manager', as: 'pick_manager'
            post 'choisir-responsable/:candidate' => 'courses#assign_course_manager', as: 'assign_course_manager'
            post 'supprimer-candidat/:candidate' => 'courses#dismiss_candidate', as: 'dismiss_candidate'
          end

          resources :activities, path: 'activites' do
            member do
              post 'choisir-candidat/:candidate' => 'activities#choose_activity_teacher', as: 'choose_activity_teacher'
              post 'retirer-enseignant/:teacher' => 'activities#dismiss_teacher', as: 'dismiss_activity_teacher'

              post 'postuler' => 'activities#apply', as: 'apply_to_activity'
              post 'retirer-candidature' => 'activities#withdraw', as: 'withdraw_activity_teaching_application'

              post 'supprimer-candidat/:candidate' => 'activities#dismiss_candidate', as: 'dismiss_activity_candidate'
              post 'demissionner' => 'activities#resign', as: 'resign_as_teacher'
            end
          end
        end
    end

    resources :teachers, path: "enseignants"
  end

  root :to => 'home#dashboard'
end
