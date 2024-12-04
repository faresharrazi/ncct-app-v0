class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_navbar_data

  private

  def set_navbar_data
    @general_account = GeneralAccount.find_by(id: 1) # Adjust the ID as necessary
    @accounts = Account.all
    @navbar_general_incomes = GeneralIncome.all || []
    @navbar_general_expenses = GeneralExpense.all || []
    @navbar_transactions = Transaction.all || []
  end
end
