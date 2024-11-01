Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :shortened_urls, only: %i[index show create]

      get "shortened_paths/:shortened_path/redirect", to: "shortened_paths#redirect"

      namespace :analytics do
        resources :shortened_urls, only: [] do
          member do
            get :total_clicks
            get :clicks_by_countries
            get :clicks
          end
        end
      end
    end
  end
end
