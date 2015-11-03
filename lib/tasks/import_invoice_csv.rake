require "csv"

namespace :import_invoices_csv do
  task create_invoices: :environment do
    CSV.foreach("public/data/invoices.csv", headers: true, header_converters: :symbol) do |row|
      Invoice.create!(row.to_hash)
    end
  end
end
