require "application_system_test_case"

class GeneralIncomesTest < ApplicationSystemTestCase
  setup do
    @general_income = general_incomes(:one)
  end

  test "visiting the index" do
    visit general_incomes_url
    assert_selector "h1", text: "General incomes"
  end

  test "should create general income" do
    visit general_incomes_url
    click_on "New general income"

    fill_in "Amount", with: @general_income.amount
    fill_in "General account", with: @general_income.general_account_id
    fill_in "Recurrence frequency", with: @general_income.recurrence_frequency
    check "Recurrent" if @general_income.recurrent
    fill_in "Title", with: @general_income.title
    click_on "Create General income"

    assert_text "General income was successfully created"
    click_on "Back"
  end

  test "should update General income" do
    visit general_income_url(@general_income)
    click_on "Edit this general income", match: :first

    fill_in "Amount", with: @general_income.amount
    fill_in "General account", with: @general_income.general_account_id
    fill_in "Recurrence frequency", with: @general_income.recurrence_frequency
    check "Recurrent" if @general_income.recurrent
    fill_in "Title", with: @general_income.title
    click_on "Update General income"

    assert_text "General income was successfully updated"
    click_on "Back"
  end

  test "should destroy General income" do
    visit general_income_url(@general_income)
    click_on "Destroy this general income", match: :first

    assert_text "General income was successfully destroyed"
  end
end
