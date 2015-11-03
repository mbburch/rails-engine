require "csv"

namespace :import_invoice_items_csv do
  task create_invoice_items: :environment do
    CSV.foreach("public/data/invoice_items.csv", headers: true, header_converters: :symbol) do |row|
      InvoiceItem.create!(row.to_hash)
    end
  end
end
