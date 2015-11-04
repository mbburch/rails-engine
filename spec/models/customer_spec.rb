require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { Customer.new(first_name: "Josh",
                                last_name: "Mejia") }

  it "creates a customer" do
    customer.save

    expect(Customer.first.first_name).to eq("Josh")
    expect(Customer.first.last_name).to eq("Mejia")
  end
end
