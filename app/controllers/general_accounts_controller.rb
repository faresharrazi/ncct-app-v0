class GeneralAccountsController < ApplicationController
  before_action :set_general_account, only: %i[ show edit update destroy ]

  # GET /general_accounts or /general_accounts.json
  def index
    @general_accounts = GeneralAccount.all
    @accounts = Account.all
    @transactions = Transaction.all
  end

  # GET /general_accounts/1 or /general_accounts/1.json
  def show
  @general_account = GeneralAccount.first # Assuming only one global account

  # Apply date filters if present
  if session[:start_date].present? && session[:end_date].present?
    start_date = session[:start_date].to_date
    end_date = session[:end_date].to_date

    @general_incomes = GeneralIncome.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    @general_expenses = GeneralExpense.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    @transactions = Transaction.where(date: start_date.beginning_of_day..end_date.end_of_day)
  else
    # No filters applied, fetch all data
    @general_incomes = GeneralIncome.all
    @general_expenses = GeneralExpense.all
    @transactions = Transaction.all
  end

  @accounts = Account.all

  # For new income and expense forms
  @general_income = GeneralIncome.new
  @general_expense = GeneralExpense.new
  end

  # GET /general_accounts/new
  def new
    @general_account = GeneralAccount.new
  end

  # GET /general_accounts/1/edit
  def edit
  end

  # POST /general_accounts or /general_accounts.json
  def create
    @general_account = GeneralAccount.new(general_account_params)

    respond_to do |format|
      if @general_account.save
        format.html { redirect_to @general_account, notice: "General account was successfully created." }
        format.json { render :show, status: :created, location: @general_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @general_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /general_accounts/1 or /general_accounts/1.json
  def update
    respond_to do |format|
      if @general_account.update(general_account_params)
        format.html { redirect_to @general_account, notice: "General account was successfully updated." }
        format.json { render :show, status: :ok, location: @general_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @general_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /general_accounts/1 or /general_accounts/1.json
  def destroy
    @general_account.destroy!

    respond_to do |format|
      format.html { redirect_to general_accounts_path, status: :see_other, notice: "General account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

   def update_net_income
    @general_account = GeneralAccount.first
    @general_account.calculate_net_income
    redirect_to @general_account, notice: "Net income updated successfully."
  end

  def filter
  # Parse Date Range
  start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
  end_date = params[:end_date].present? ? Date.parse(params[:end_date]).end_of_day : nil

  # Parse Month
  if params[:month].present?
    year, month = params[:month].split('-').map(&:to_i)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month.end_of_day
  end

  # Store filters in session
  session[:start_date] = start_date
  session[:end_date] = end_date

  redirect_to request.referer || root_path, notice: "Filters applied."
end


def clear
  # Clear filters from the session
  session[:start_date] = nil
  session[:end_date] = nil

  # Redirect back to the current page
  redirect_back fallback_location: root_path, notice: "Filters cleared."
end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_general_account
      @general_account = GeneralAccount.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def general_account_params
      params.expect(general_account: [ :net_income ])
    end
end
