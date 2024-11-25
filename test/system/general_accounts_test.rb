require "application_system_test_case"

class GeneralAccountsTest < ApplicationSystemTestCase
  setup do
    @general_account = general_accounts(:one)
  end

  test "visiting the index" do
    visit general_accounts_url
    assert_selector "h1", text: "General accounts"
  end

  test "should create general account" do
    visit general_accounts_url
    click_on "New general account"

    fill_in "Net income", with: @general_account.net_income
    click_on "Create General account"

    assert_text "General account was successfully created"
    click_on "Back"
  end

  test "should update General account" do
    visit general_account_url(@general_account)
    click_on "Edit this general account", match: :first

    fill_in "Net income", with: @general_account.net_income
    click_on "Update General account"

    assert_text "General account was successfully updated"
    click_on "Back"
  end

  test "should destroy General account" do
    visit general_account_url(@general_account)
    click_on "Destroy this general account", match: :first

    assert_text "General account was successfully destroyed"
  end
end
