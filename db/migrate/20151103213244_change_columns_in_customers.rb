class ChangeColumnsInCustomers < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    change_column :customers, :first_name, :citext
    change_column :customers, :last_name, :citext
  end
end
