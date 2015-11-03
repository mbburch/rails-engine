class ChangeColumnInInvoices < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    change_column :invoices, :status, :citext
  end
end
