json.extract! general_expense, :id, :title, :amount, :recurrent, :recurrence_frequency, :general_account_id, :created_at, :updated_at
json.url general_expense_url(general_expense, format: :json)