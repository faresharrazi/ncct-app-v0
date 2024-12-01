class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  # GET /accounts or /accounts.json
  def index
    @general_account = GeneralAccount.find(1)
    @accounts = Account.all
    @transactions = Transaction.order(date: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @transactions = @transactions.where(date: session[:start_date]..session[:end_date]).order(date: :desc)
    end
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    @accounts = Account.all
    @categories = @account.categories
    @new_category = Category.new
    @transactions = @account.transactions.order(date: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @transactions = @transactions.where(date: session[:start_date]..session[:end_date]).order(date: :desc)
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    @categories = @account.categories # Fetch categories linked to the account
    @new_category = Category.new      # Initialize a new category for the form
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)
    @account.general_account_id = 1 # Default General Account ID

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_path, status: :see_other, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /accounts/:id/categories
  def categories
    @account = Account.find(params[:id])
    render json: @account.categories.select(:id, :name)
  end

  # GET /accounts/:id/transactions
  def transactions
    @account = Account.find(params[:id])
    @transactions = @account.transactions

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @transactions = @transactions.where(date: session[:start_date]..session[:end_date])
    end
  end

  # GET /accounts/:id/ui_categories
  def ui_categories
    @categories = @account.categories
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:title, :percentage, :general_account_id)
  end
end
