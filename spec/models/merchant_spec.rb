require 'rails_helper'

RSpec.describe Merchant, type: :model do
  let(:merchant) { Merchant.new(name: "Merchant") }

  it "creates a merchant" do
    merchant.save

    expect(Merchant.first.name).to eq("Merchant")
  end
end
