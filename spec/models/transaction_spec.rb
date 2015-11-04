require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { Transaction.new(credit_card_number: "1234123412341234",
                                      result: "success") }

  it "creates a transaction" do
    transaction.save

    expect(Transaction.first.result).to eq("success")
  end
end
