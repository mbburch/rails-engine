require "csv"

namespace :import_items_csv do
  task create_items: :environment do
    CSV.foreach("public/data/items.csv", headers: true, header_converters: :symbol) do |row|
      Item.create!(row.to_hash)
    end
  end
end
