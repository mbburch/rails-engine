class ChangeColumnInTransactions < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    change_column :transactions, :result, :citext
  end
end
