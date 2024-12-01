class GeneralExpensesController < ApplicationController
  before_action :set_general_expense, only: %i[show edit update destroy]

  # GET /general_expenses or /general_expenses.json
  def index
    @general_expenses = GeneralExpense.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_expenses = @general_expenses.where(created_at: session[:start_date]..session[:end_date]).order(created_at: :desc)
    end
  end

  # GET /general_expenses/1 or /general_expenses/1.json
  def show
    # Apply Date Range Filters for Show if needed
  end

  # GET /general_expenses/new
  def new
    @general_expense = GeneralExpense.new
    @general_expenses = GeneralExpense.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_expenses = @general_expenses.where(created_at: session[:start_date]..session[:end_date])
    end
  end

  # GET /general_expenses/1/edit
  def edit
    @general_expenses = GeneralExpense.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_expenses = @general_expenses.where(created_at: session[:start_date]..session[:end_date])
    end
  end

  # POST /general_expenses or /general_expenses.json
  def create
    @general_expense = GeneralExpense.new(general_expense_params)
    @general_expense.general_account_id = 1 # Default General Account ID

    respond_to do |format|
      if @general_expense.save
        format.html { redirect_to new_general_expense_path, notice: "General expense was successfully created." }
        format.json { render :show, status: :created, location: @general_expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @general_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /general_expenses/1 or /general_expenses/1.json
  def update
    respond_to do |format|
      if @general_expense.update(general_expense_params)
        format.html { redirect_to edit_general_expense_path, notice: "General expense was successfully updated." }
        format.json { render :show, status: :ok, location: @general_expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @general_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /general_expenses/1 or /general_expenses/1.json
  def destroy
    @general_expense.destroy!

    respond_to do |format|
      format.html { redirect_to general_expenses_path, status: :see_other, notice: "General expense was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_general_expense
    @general_expense = GeneralExpense.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def general_expense_params
    params.require(:general_expense).permit(:title, :amount, :general_account_id)
  end
end
