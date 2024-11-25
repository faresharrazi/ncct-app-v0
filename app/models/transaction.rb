class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  scope :by_account, ->(account_id) { where(account_id: account_id) if account_id.present? }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) if start_date && end_date }
  scope :by_amount_range, ->(min_amount, max_amount) { where(amount: min_amount..max_amount) if min_amount && max_amount }
  scope :search_by_name, ->(query) { where('name ILIKE ?', "%#{query}%") if query.present? }

end
