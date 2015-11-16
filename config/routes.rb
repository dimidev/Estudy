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

    scope path: 'dashboard', controller: :dashboards do
      get 'home', as: :dashboard_home
    end

    resource :institution, except: :destroy
    resource :superadmin, only: [:edit, :update]
    resources :buildings, shallow: true do
      resources :halls, except: :show
    end
    scope '/halls', controller: :halls do
      get 'view_all_halls', action: :view_all
    end
  
    resources :departments, shallow: true do
      resources :admins
      resources :professors
      resources :students do
        resources :registrations do
          get 'current', on: :collection
        end
        resources :grades
      end
      resources :studies_programmes do
        resources :courses
      end
      resources :timetables do
        get 'current', on: :collection
      end
      resources :course_classes do
        get 'students', on: :member
      end
      resources :exams
    end
    resources :notices

    get 'users/sign_out', as: :logout
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  get '', to: redirect("/#{I18n.default_locale}")
end
