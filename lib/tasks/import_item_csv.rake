require "csv"

namespace :import_items_csv do
  task create_items: :environment do
    CSV.foreach("public/data/items.csv", headers: true, header_converters: :symbol) do |row|
      Item.create!({
        name: row[1],
        description: row[2],
        unit_price: (row[3].to_f / 100.00),
        merchant_id: row[4],
        created_at:  row[5],
        updated_at:  row[6]
      })
    end
  end
end


