class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @new_category = Category.new(account_id: @category.account_id)
    @account = @category.account
    @categories = @account.categories
  end

  # POST /categories or /categories.json
def create
  @category = Category.new(category_params)

  respond_to do |format|
    if @category.save
      if @category.account_id.present?
        format.html { redirect_to edit_account_path(@category.account_id), notice: "Category was successfully created." }
      else
        format.html { redirect_to @category, notice: "Category was successfully created." }
      end
      format.json { render :show, status: :created, location: @category }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @category.errors, status: :unprocessable_entity }
    end
  end
end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to edit_account_path(@category.account_id), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
def destroy
  if @category.destroy
    flash[:notice] = "Category was successfully destroyed."
  else
    flash[:alert] = "Category could not be destroyed: #{@category.errors.full_messages.to_sentence}"
  end

  redirect_to edit_account_path(@category.account_id), status: :see_other
end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
    @account = @category.account # Ensure the associated account is loaded
  end

    # Only allow a list of trusted parameters through.
    def category_params
      params.expect(category: [ :name, :account_id ])
    end
end
