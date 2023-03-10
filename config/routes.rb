Rails.application.routes.draw do
  resources :survey_tokens
  resources :survey_projects do
    resources :surveys
  end
  resources :surveys
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "survey_tokens#index"
end
