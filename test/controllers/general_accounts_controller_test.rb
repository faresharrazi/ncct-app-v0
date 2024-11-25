require "test_helper"

class GeneralAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @general_account = general_accounts(:one)
  end

  test "should get index" do
    get general_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_general_account_url
    assert_response :success
  end

  test "should create general_account" do
    assert_difference("GeneralAccount.count") do
      post general_accounts_url, params: { general_account: { net_income: @general_account.net_income } }
    end

    assert_redirected_to general_account_url(GeneralAccount.last)
  end

  test "should show general_account" do
    get general_account_url(@general_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_general_account_url(@general_account)
    assert_response :success
  end

  test "should update general_account" do
    patch general_account_url(@general_account), params: { general_account: { net_income: @general_account.net_income } }
    assert_redirected_to general_account_url(@general_account)
  end

  test "should destroy general_account" do
    assert_difference("GeneralAccount.count", -1) do
      delete general_account_url(@general_account)
    end

    assert_redirected_to general_accounts_url
  end
end
