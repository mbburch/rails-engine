require 'rails_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of merchants" do
      Merchant.create!(name: "Merchant One")
      Merchant.create!(name: "Merchant Two")
      Merchant.create!(name: "Merchant Three")

      number_of_merchants = Merchant.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_merchants).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @merchant = Merchant.create!(name: "Merchant One")
      Merchant.create!(name: "Merchant Two")
      Merchant.create!(name: "Merchant Three")
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @merchant.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct merchant" do
      get :show, format: :json, id: @merchant.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect("Merchant One").to eq(json_response[:name])
    end
  end

  describe "GET #find" do
    before do
      Merchant.create!(name: "Merchant One")
      @merchant = Merchant.create!(name: "Merchant Two")
      Merchant.create!(name: "Merchant Three")
    end

    it "responds with 200 success" do
      get :find, format: :json, name: "Merchant Two"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct merchant with name" do
      get :find, format: :json, name: "Merchant Two"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(@merchant.id).to eq(json_response[:id])
    end
  end

  describe "GET #find_all" do
    before do
      Merchant.create!(name: "Merchant One")
      Merchant.create!(name: "Merchant Two")
      Merchant.create!(name: "Merchant Three")
    end

    it "responds with 200 success" do
      get :find_all, format: :json, name: "Merchant Three"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct merchants with name" do
      get :find_all, format: :json, name: "Merchant One"
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(1)
    end
  end

  describe "GET #random" do
    before do
      Merchant.create!(name: "Merchant One")
      Merchant.create!(name: "Merchant Two")
      Merchant.create!(name: "Merchant Three")
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random merchant" do
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

  describe "GET #items" do
    before do
      @merchant = Merchant.create!(name: "Merchant One")
      Item.create!(merchant_id: @merchant.id, name: "item", description: "awesome", unit_price: 12345)
      Item.create!(merchant_id: @merchant.id, name: "another item", description: "wow", unit_price: 123)
    end

    it "responds with 200 success" do
      get :items, format: :json, id: @merchant.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all merchant items" do
      get :items, format: :json, id: @merchant.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:merchant_id]).to eq(@merchant.id)
    end
  end

  describe "GET #invoices" do
    before do
      @merchant = Merchant.create!(name: "Merchant One")
      Invoice.create!(merchant_id: @merchant.id, status: "shipped")
      Invoice.create!(merchant_id: @merchant.id, status: "shipped")
    end

    it "responds with 200 success" do
      get :invoices, format: :json, id: @merchant.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all merchant invoices" do
      get :invoices, format: :json, id: @merchant.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:merchant_id]).to eq(@merchant.id)
    end
  end

  describe "GET #favorite_customer" do
    before do
      @merchant = Merchant.create!(name: "Merchant One")
      @customer = Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")
      @invoice_one   = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant.id, status: "shipped")
                       Invoice.create!(customer_id: @customer.id, merchant_id: @merchant.id, status: "shipped")
      @invoice_three = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant.id, status: "shipped")
      @trans_one     = Transaction.create!(invoice_id: @invoice_one.id, credit_card_number: "1234123412341234", result: "success")
      @trans_two     = Transaction.create!(invoice_id: @invoice_one.id, credit_card_number: "4321432143214321", result: "failed")
      @trans_three   = Transaction.create!(invoice_id: @invoice_three.id, credit_card_number: "1234567812345678", result: "success")
    end

    it "responds with 200 success" do
      get :favorite_customer, format: :json, id: @merchant.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns favorite_customer" do
      get :favorite_customer, format: :json, id: @merchant.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:first_name]).to eq("Josh")
      expect(json_response[:id]).to eq(@customer.id)
    end
  end

  describe "GET #customers_with_pending_invoices" do
    before do
      @merchant      = Merchant.create!(name: "Merchant One")
      @customer      = Customer.create!(first_name: "Josh", last_name: "Mejia")
      @customer_two  = Customer.create!(first_name: "Jorge", last_name: "Tellez")
      @invoice_one   = Invoice.create!(customer_id: @customer.id, merchant_id: @merchant.id, status: "shipped")
                       Invoice.create!(customer_id: @customer.id, merchant_id: @merchant.id, status: "shipped")
      @invoice_three = Invoice.create!(customer_id: @customer_two.id, merchant_id: @merchant.id, status: "shipped")
      @trans_one     = Transaction.create!(invoice_id: @invoice_one.id, credit_card_number: "1234123412341234", result: "success")
      @trans_two     = Transaction.create!(invoice_id: @invoice_one.id, credit_card_number: "4321432143214321", result: "failed")
      @trans_three   = Transaction.create!(invoice_id: @invoice_three.id, credit_card_number: "1234567812345678", result: "failed")
    end

    it "responds with 200 success" do
      get :customers_with_pending_invoices, format: :json, id: @merchant.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns customers_with_pending_invoices" do
      get :customers_with_pending_invoices, format: :json, id: @merchant.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response.count).to eq(2)
      expect(json_response[0][:first_name]).to eq("Josh")
      expect(json_response[1][:first_name]).to eq("Jorge")
    end
  end
end
