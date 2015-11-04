require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { Item.new(name: "item",
                        description: "yay item",
                        unit_price: 12345) }

  it "creates an item" do
    item.save

    expect(Item.first.name).to eq("item")
    expect(Item.first.description).to eq("yay item")
  end
end
