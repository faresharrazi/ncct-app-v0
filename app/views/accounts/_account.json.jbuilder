json.extract! account, :id, :title, :balance, :percentage, :general_account_id, :created_at, :updated_at
json.url account_url(account, format: :json)
