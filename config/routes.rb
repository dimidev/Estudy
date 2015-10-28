Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, controllers: {
         sessions: 'users/sessions',
         devise: 'users/devise',
         passwords: 'users/passwords',
         registrations: 'users/registrations'
     }

    root 'dashboards#home'

    scope path: 'dashboard', controller: :dashboards do
      get 'home', as: :dashboard_home
    end

    resource :institution, except: :destroy
    resource :superadmin, only: [:edit, :update]

    resources :departments, shallow: true do
      resources :admins
      resources :professors
      resources :students do
        resources :registrations do
          get 'current', on: :collection
        end
      end
      resources :studies_programmes do
        resources :courses
      end
    end

    get 'users/sign_out', as: :logout
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  get '', to: redirect("/#{I18n.default_locale}")
end
