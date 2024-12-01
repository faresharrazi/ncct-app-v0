class GeneralIncomesController < ApplicationController
  before_action :set_general_income, only: %i[show edit update destroy]

  # GET /general_incomes or /general_incomes.json
  def index
    @general_incomes = GeneralIncome.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_incomes = @general_incomes.where(created_at: session[:start_date]..session[:end_date]).order(created_at: :desc)
    end
  end

  # GET /general_incomes/1 or /general_incomes/1.json
  def show
    # Date range filtering isn't applied directly to a single record
  end

  # GET /general_incomes/new
  def new
    @general_income = GeneralIncome.new
    @general_incomes = GeneralIncome.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_incomes = @general_incomes.where(created_at: session[:start_date]..session[:end_date])
    end
  end

  # GET /general_incomes/1/edit
  def edit
    @general_incomes = GeneralIncome.order(created_at: :desc)

    # Apply Date Range Filters
    if session[:start_date] && session[:end_date]
      @general_incomes = @general_incomes.where(created_at: session[:start_date]..session[:end_date])
    end
  end

  # POST /general_incomes or /general_incomes.json
  def create
    @general_income = GeneralIncome.new(general_income_params)
    @general_income.general_account_id = 1 # Default General Account ID

    respond_to do |format|
      if @general_income.save
        format.html { redirect_to new_general_income_path, notice: "General income was successfully created." }
        format.json { render :show, status: :created, location: @general_income }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @general_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /general_incomes/1 or /general_incomes/1.json
  def update
    respond_to do |format|
      if @general_income.update(general_income_params)
        format.html { redirect_to edit_general_income_path, notice: "General income was successfully updated." }
        format.json { render :show, status: :ok, location: @general_income }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @general_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /general_incomes/1 or /general_incomes/1.json
  def destroy
    @general_income.destroy!

    respond_to do |format|
      format.html { redirect_to general_incomes_path, status: :see_other, notice: "General income was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_general_income
    @general_income = GeneralIncome.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def general_income_params
    params.require(:general_income).permit(:title, :amount, :general_account_id)
  end
end
