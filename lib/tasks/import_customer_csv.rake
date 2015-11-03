require "csv"

namespace :import_customers_csv do
  task create_customers: :environment do
    CSV.foreach("public/data/customers.csv", headers: true, header_converters: :symbol) do |row|
      Customer.create!(row.to_hash)
    end
  end
end
