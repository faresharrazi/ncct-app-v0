class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
    @transactions = @transactions.by_account(params[:account_id])
    @transactions = @transactions.by_category(params[:category_id])
    @transactions = @transactions.by_date_range(params[:start_date], params[:end_date])
    @transactions = @transactions.by_amount_range(params[:min_amount], params[:max_amount])
    @transactions = @transactions.search_by_name(params[:query])
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    # Use the default category if none is selected
    if @transaction.category_id.blank?
      default_category = @transaction.account.categories.find_by(name: @transaction.account.title)
      @transaction.category_id = default_category.id if default_category
    end

    respond_to do |format|
      if @transaction.save
        Rails.logger.info("Transaction created successfully: #{@transaction.inspect}")
        format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        Rails.logger.error("Transaction creation failed: #{@transaction.errors.full_messages}")
        Rails.logger.error("Transaction attributes: #{@transaction.attributes}")
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
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
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
      format.html { redirect_to transactions_path, status: :see_other, notice: "Transaction was successfully destroyed." }
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
      params.expect(transaction: [ :name, :amount, :date, :account_id, :category_id ])
    end
end
