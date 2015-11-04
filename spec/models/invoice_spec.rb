require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:invoice) { Invoice.new(status: "shipped") }

  it "creates an invoice" do
    invoice.save

    expect(Invoice.first.status).to eq("shipped")
  end
end
