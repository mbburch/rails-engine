require 'rails_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of invoices" do
      Invoice.create!(status: "shipped")
      Invoice.create!(status: "shipped")

      number_of_invoices = Invoice.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_invoices).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @invoice = Invoice.create!(status: "shipped")
      Invoice.create!(status: "shipped")
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoice" do
      get :show, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect("shipped").to eq(json_response[:status])
      expect(@invoice.id).to eq(json_response[:id])
    end
  end

  describe "GET #find" do
    before do
      @invoice = Invoice.create!(status: "shipped")
      Invoice.create!(status: "shipped")
    end

    it "responds with 200 success" do
      get :find, format: :json, status: "shipped"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoice with status" do
      get :find, format: :json, status: "shipped"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect("shipped").to eq(json_response[:status])
    end

    it "returns the correct invoice with id" do
      get :find, format: :json, id: @invoice.id
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(@invoice.id).to eq(json_response[:id])
    end
  end

  describe "GET #find_all" do
    before do
      @invoice = Invoice.create!(status: "shipped")
      Invoice.create!(status: "shipped")
    end

    it "responds with 200 success" do
      get :find_all, format: :json, status: "shipped"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoices with status" do
      get :find_all, format: :json, status: "shipped"
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
    end
  end

  describe "GET #random" do
    before do
      Invoice.create!(status: "shipped")
      Invoice.create!(status: "shipped")
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random invoice" do
      @results = []

      10.times do
        get :random, format: :json
        response_one = JSON.parse(response.body, symbolize_names: true)
        get :random, format: :json
        response_two = JSON.parse(response.body, symbolize_names: true)

        @results << (response_one == response_two)
      end
      expect(@results.include?(false)).to eq true
    end
  end

  describe "GET #transactions" do
    before do
      @invoice     = Invoice.create!(status: "shipped")
      @transaction_one = Transaction.create!(invoice_id: @invoice.id, credit_card_number: "1234123412341234", result: "success")
      @transaction_two = Transaction.create!(invoice_id: @invoice.id, credit_card_number: "1234567812345678", result: "success")

    end

    it "responds with 200 success" do
      get :transactions, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all associated transactions" do
      get :transactions, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:invoice_id]).to eq(@invoice.id)
    end
  end

  describe "GET #invoice_items" do
    before do
      @invoice     = Invoice.create!(status: "shipped")
      @one = InvoiceItem.create!(invoice_id: @invoice.id, quantity: 2, unit_price: 12345)
      @two = InvoiceItem.create!(invoice_id: @invoice.id, quantity: 4, unit_price: 54321)

    end

    it "responds with 200 success" do
      get :invoice_items, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all associated invoice items" do
      get :invoice_items, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:invoice_id]).to eq(@invoice.id)
    end
  end

  describe "GET #items" do
    before do
      @invoice     = Invoice.create!(status: "shipped")
      @item_one    = Item.create!(name: "item", description: "awesome", unit_price: 12345)
      @item_two    = Item.create!(name: "item two", description: "cool", unit_price: 54321)
      InvoiceItem.create!(item_id: @item_one.id, invoice_id: @invoice.id, quantity: 2, unit_price: 12345)
      InvoiceItem.create!(item_id: @item_two.id, invoice_id: @invoice.id, quantity: 4, unit_price: 54321)
    end

    it "responds with 200 success" do
      get :items, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated items" do
      get :items, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:id]).to eq(@item_one.id)
    end
  end

  describe "GET #customer" do
    before do
      @customer = Customer.create!(first_name: "Josh", last_name: "Mejia")
      @invoice  = Invoice.create!(customer_id: @customer.id, status: "shipped")
    end

    it "responds with 200 success" do
      get :customer, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated customer" do
      get :customer, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:id]).to eq(@customer.id)
    end
  end

  describe "GET #merchant" do
    before do
      @merchant = Merchant.create!(name: "Merchant")
      @invoice  = Invoice.create!(merchant_id: @merchant.id, status: "shipped")
    end

    it "responds with 200 success" do
      get :merchant, format: :json, id: @invoice.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated merchant" do
      get :merchant, format: :json, id: @invoice.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:id]).to eq(@merchant.id)
    end
  end
end
