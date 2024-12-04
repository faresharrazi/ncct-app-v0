# require 'faker'

# Clear existing data
# puts "Clearing database..."
# Transaction.destroy_all
#  Category.destroy_all
# Account.destroy_all
# GeneralIncome.destroy_all
# GeneralExpense.destroy_all


# # Create General Account
# puts "Creating General Account..."
# general_account = GeneralAccount.create!(net_income: 0)

# Find or create the global General Account
# general_account = GeneralAccount.find_or_create_by!(id: 1) do |account|
#   account.net_income = 0
# end

# # Create 4 General Incomes
# puts "Creating General Incomes..."
# [2000, 3000, 500, 700].each do |amount|
#   GeneralIncome.create!(
#     title: Faker::Commerce.department(max: 1, fixed_amount: true),
#     amount: amount,
#     general_account: general_account
#   )
# end

# # Create 2 General Expenses
# puts "Creating General Expenses..."
# [500, 200].each do |amount|
#   GeneralExpense.create!(
#     title: Faker::Commerce.product_name,
#     amount: amount,
#     general_account: general_account
#   )
# end

# # Create 4 Accounts with specified percentages
# puts "Creating Accounts..."
# accounts = []
# [40, 30, 20, 10].each do |percentage|
#   accounts << Account.create!(
#     title: Faker::Company.name,
#     percentage: percentage,
#     balance: (general_account.net_income * percentage / 100.0).round(2),
#     general_account: general_account
#   )
# end

# Create 4 Categories for each Account
# accounts = Account.all
# puts "Creating Categories..."
# accounts.each do |account|
#   4.times do
#     Category.create!(
#       name: Faker::Commerce.department,
#       account: account
#     )
#   end
# end

# Generate 100 Random Transactions
# puts "Creating Transactions..."
# accounts = Account.all
# categories = Category.all
# 100.times do
#   account = accounts.sample
#   Transaction.create!(
#     name: Faker::Commerce.product_name,
#     amount: Faker::Commerce.price(range: 10.0..50.0),
#     date: Faker::Date.between(from: 1.year.ago, to: Date.today),
#     account: account,
#     category: categories.where(account: account).sample
#   )
# end

# puts "Seeding complete!"
