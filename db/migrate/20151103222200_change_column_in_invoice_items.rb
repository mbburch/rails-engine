class ChangeColumnInInvoiceItems < ActiveRecord::Migration
  def change
    change_column :invoice_items, :unit_price, :decimal, precision: 8, scale: 2
  end
end
