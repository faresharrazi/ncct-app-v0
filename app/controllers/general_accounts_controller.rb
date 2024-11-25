class GeneralAccountsController < ApplicationController
  before_action :set_general_account, only: %i[ show edit update destroy ]

  # GET /general_accounts or /general_accounts.json
  def index
    @general_accounts = GeneralAccount.all
  end

  # GET /general_accounts/1 or /general_accounts/1.json
  def show
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
