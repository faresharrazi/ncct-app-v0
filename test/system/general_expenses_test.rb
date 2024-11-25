require "application_system_test_case"

class GeneralExpensesTest < ApplicationSystemTestCase
  setup do
    @general_expense = general_expenses(:one)
  end

  test "visiting the index" do
    visit general_expenses_url
    assert_selector "h1", text: "General expenses"
  end

  test "should create general expense" do
    visit general_expenses_url
    click_on "New general expense"

    fill_in "Amount", with: @general_expense.amount
    fill_in "General account", with: @general_expense.general_account_id
    fill_in "Recurrence frequency", with: @general_expense.recurrence_frequency
    check "Recurrent" if @general_expense.recurrent
    fill_in "Title", with: @general_expense.title
    click_on "Create General expense"

    assert_text "General expense was successfully created"
    click_on "Back"
  end

  test "should update General expense" do
    visit general_expense_url(@general_expense)
    click_on "Edit this general expense", match: :first

    fill_in "Amount", with: @general_expense.amount
    fill_in "General account", with: @general_expense.general_account_id
    fill_in "Recurrence frequency", with: @general_expense.recurrence_frequency
    check "Recurrent" if @general_expense.recurrent
    fill_in "Title", with: @general_expense.title
    click_on "Update General expense"

    assert_text "General expense was successfully updated"
    click_on "Back"
  end

  test "should destroy General expense" do
    visit general_expense_url(@general_expense)
    click_on "Destroy this general expense", match: :first

    assert_text "General expense was successfully destroyed"
  end
end
