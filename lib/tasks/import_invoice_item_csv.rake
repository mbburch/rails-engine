require "csv"

namespace :import_invoice_items_csv do
  task create_invoice_items: :environment do
    CSV.foreach("public/data/invoice_items.csv", headers: true, header_converters: :symbol) do |row|
      InvoiceItem.create!({
           :item_id    => row[1],
           :invoice_id => row[2],
           :quantity   => row[3],
           :unit_price => (row[4].to_f / 100),
           :created_at => row[5],
           :updated_at => row[6]
          })
    end
  end
end
