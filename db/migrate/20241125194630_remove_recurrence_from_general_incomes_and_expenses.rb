class RemoveRecurrenceFromGeneralIncomesAndExpenses < ActiveRecord::Migration[8.0]
  def change
    remove_column :general_incomes, :recurrent, :boolean
    remove_column :general_incomes, :recurrence_frequency, :integer
    remove_column :general_expenses, :recurrent, :boolean
    remove_column :general_expenses, :recurrence_frequency, :integer
  end
end
