ChocRor::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords", :confirmations => "users/confirmations"} do
    put "confirm", to: "users/confirmations#confirm"
  end

  devise_scope :user do
    root :to => "devise/sessions#new"
  end

  resources :users do
    collection do
      get 'reset_password'
      get 'app_admin_confirm'
    end
  end

  # API Routes
  get 'api/v1/releases/show_release/:language', to: 'api/v1/releases#show_release'
  post '/api/v1/users', to: 'api/v1/users#create'
  post '/api/v1/user_auth/sign_in', to: 'api/v1/user_auths#sign_in'
  post '/api/v1/user_auth/forgot_password', to: 'api/v1/user_auths#forgot_password'
  post '/api/v1/user_auth/resend_confirmation_email', to: 'api/v1/user_auths#resend_confirmation_email'
  post '/api/v1/events', to: 'api/v1/events#create'
  post '/api/v1/patient_forms/save_images', to: 'api/v1/patient_forms#save_images'
  post '/api/v1/patient_forms/email_release_form', to: 'api/v1/patient_forms#email_release_form'
  post '/api/v1/patient_forms', to: 'api/v1/patient_forms#create'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resource :user_auth, only: [] do
        member do
          post 'sign_in'
          post 'forgot_password'
          post 'resend_confirmation_email'
        end
      end
      resources :events, only: [:create] do
        collection do
          get 'get_upcoming_events'
          get 'get_permanent_events'
        end
      end
      resources :uses, only: [:index]
      resources :patient_forms, only: [:create] do
        collection do
          post 'save_images'
          get 'patient_details'
          get 'patient_info'
          post 'email_release_form'
        end
      end
      resources :patients, only: [] do
        collection do
          get 'search'
        end
      end
    end
  end
end