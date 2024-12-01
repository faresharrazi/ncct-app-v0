class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

def index
  @general_account = GeneralAccount.find_by(id: 1)
  @account = Account.find_by(id: params[:account_id]) # Optional account
  @transactions = Transaction.order(date: :desc)

  # Apply Date Range from Session
  if session[:start_date].present? && session[:end_date].present?
    @transactions = @transactions.where(date: session[:start_date]..session[:end_date]).order(date: :desc)
  end

  # Apply Additional Filters
  @transactions = @transactions.by_account(params[:account_id]) if params[:account_id].present?
  @transactions = @transactions.by_category(params[:category_id]) if params[:category_id].present?
  @transactions = @transactions.by_date_range(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
  @transactions = @transactions.by_amount_range(params[:min_amount], params[:max_amount]) if params[:min_amount].present? && params[:max_amount].present?
  @transactions = @transactions.search_by_name(params[:query]) if params[:query].present?
end


  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @transactions = Transaction.order(date: :desc)
  end

  # GET /transactions/1/edit
  def edit
    @categories = @transaction.account.categories if @transaction.account
    @transactions = Transaction.order(date: :desc)
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)



    respond_to do |format|
      if @transaction.save
        format.html { redirect_to new_transaction_path, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
       
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    Rails.logger.error("Unexpected error during transaction creation: #{e.message}")
    Rails.logger.error("Backtrace: #{e.backtrace.take(10).join("\n")}")
    respond_to do |format|
      format.html { redirect_to transactions_path, alert: "An error occurred while creating the transaction. Please try again." }
      format.json { render json: { error: "Internal Server Error" }, status: :internal_server_error }
    end
  end


  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to edit_transaction_path, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /transactions/1 or /transactions/1.json
def destroy
  @transaction.destroy!

  respond_to do |format|
    format.html { redirect_back fallback_location: transactions_path, notice: "Transaction was successfully destroyed." }
    format.json { head :no_content }
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:name, :amount, :date, :account_id, :category_id)
  end
end
