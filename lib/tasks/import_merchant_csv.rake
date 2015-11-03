require "csv"

namespace :import_merchants_csv do
  task create_merchants: :environment do
    CSV.foreach("public/data/merchants.csv", headers: true, header_converters: :symbol) do |row|
      Merchant.create!(row.to_hash)
    end
  end
end
