class AddMerchantIdToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :merchant, index: true, foreign_key: true
  end
end
