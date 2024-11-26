Rails.application.routes.draw do
  resources :transactions
  resources :categories
  resources :accounts
  resources :general_expenses
  resources :general_incomes
  resources :general_accounts

  get "up" => "rails/health#show", as: :rails_health_check

  root "general_accounts#show", id: 1 # Assuming you have one GeneralAccount with ID 1

  resources :accounts do
  member do
    get :categories
  end
end
  
end
