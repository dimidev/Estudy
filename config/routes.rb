Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, controllers: {
         sessions: 'users/sessions',
         devise: 'users/devise',
         passwords: 'users/passwords',
         registrations: 'users/registrations'
     }

    root 'dashboards#show'

    scope '/dashboard', controller: :dashboards do
      get 'home', as: :dashboard_home
    end

    resource :institution, except: :destroy
    resource :superadmin, only: [:edit, :update]
    resources :buildings, except: :show, shallow: true do
      resources :halls, except: :show
    end
    scope '/halls', controller: :halls do
      get 'view_all_halls', action: :view_all
    end
  
    resources :departments, shallow: true do
      resources :admins
      resources :professors
      resources :students do
        get 'grades', on: :member

        resources :registrations do
          get 'current', on: :collection
        end
      end
      resources :studies_programmes do
        resources :courses
      end
      resources :timetables do
        get 'current', on: :collection
      end
      resources :course_classes do
        get 'students', on: :member
        resources :attendances
      end
      resources :exams do
        resources :exam_courses do
          member do
            get 'edit_attendances'
            get 'edit_grades'
            patch 'save_attendances'
            patch 'save_grades'
          end
        end
      end
    end
    resources :conversations
    resources :notices

    get 'users/sign_out', as: :logout
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  get '', to: redirect("/#{I18n.default_locale}")
end
