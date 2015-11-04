require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  let(:invoice_item) { InvoiceItem.new(quantity: 2,
                                       unit_price: "12345") }

  it "creates an invoice item" do
    invoice_item.save

    expect(InvoiceItem.first.quantity).to eq(2)
    expect(InvoiceItem.first.unit_price).to eq(12345.0)
  end
end
