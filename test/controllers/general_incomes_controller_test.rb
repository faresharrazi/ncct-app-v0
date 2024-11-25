require "test_helper"

class GeneralIncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @general_income = general_incomes(:one)
  end

  test "should get index" do
    get general_incomes_url
    assert_response :success
  end

  test "should get new" do
    get new_general_income_url
    assert_response :success
  end

  test "should create general_income" do
    assert_difference("GeneralIncome.count") do
      post general_incomes_url, params: { general_income: { amount: @general_income.amount, general_account_id: @general_income.general_account_id, recurrence_frequency: @general_income.recurrence_frequency, recurrent: @general_income.recurrent, title: @general_income.title } }
    end

    assert_redirected_to general_income_url(GeneralIncome.last)
  end

  test "should show general_income" do
    get general_income_url(@general_income)
    assert_response :success
  end

  test "should get edit" do
    get edit_general_income_url(@general_income)
    assert_response :success
  end

  test "should update general_income" do
    patch general_income_url(@general_income), params: { general_income: { amount: @general_income.amount, general_account_id: @general_income.general_account_id, recurrence_frequency: @general_income.recurrence_frequency, recurrent: @general_income.recurrent, title: @general_income.title } }
    assert_redirected_to general_income_url(@general_income)
  end

  test "should destroy general_income" do
    assert_difference("GeneralIncome.count", -1) do
      delete general_income_url(@general_income)
    end

    assert_redirected_to general_incomes_url
  end
end
