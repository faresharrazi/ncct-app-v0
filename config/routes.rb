Rails.application.routes.draw do
  resources :transactions
  resources :categories
  resources :accounts
  resources :general_expenses
  resources :general_incomes
  resources :general_accounts

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route points to GeneralAccount's show or index
  root "general_accounts#show", id: 1 # Assuming you have one GeneralAccount with ID 1

  # Alternative: if you want an index view instead:
  # root "general_accounts#index"
end
