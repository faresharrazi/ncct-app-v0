Rails.application.routes.draw do
  resources :transactions
  resources :categories
  resources :accounts
  resources :general_expenses
  resources :general_incomes
  resources :general_accounts

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "general_accounts#show", id: 1 # Assuming you have one GeneralAccount with ID 1

  # Account-specific routes
  resources :accounts do
    member do
      get :transactions # For account_transactions_path
      get :categories   # For account_categories_path
      get :ui_categories # For AJAX-based category fetching (Stimulus)
    end
  end

  get 'filter', to: 'general_accounts#filter'
  get 'clear_filters', to: 'general_accounts#clear'
end
