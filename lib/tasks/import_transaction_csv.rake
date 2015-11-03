require "csv"

namespace :import_transactions_csv do
  task create_transactions: :environment do
    CSV.foreach("public/data/transactions.csv", headers: true, header_converters: :symbol) do |row|
      Transaction.create!(row.to_hash)
    end
  end
end
