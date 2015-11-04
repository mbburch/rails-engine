require 'rails_helper'

RSpec.describe Api::V1::InvoiceItemsController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of invoice items" do
      InvoiceItem.create!(quantity: 2, unit_price: 12345)
      InvoiceItem.create!(quantity: 4, unit_price: 54321)

      number_of_invoice_items = InvoiceItem.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_invoice_items).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @item_one = InvoiceItem.create!(quantity: 2, unit_price: 12345)
      InvoiceItem.create!(quantity: 4, unit_price: 54321)
      InvoiceItem.create!(quantity: 2, unit_price: 2345)
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @item_one.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoice item" do
      get :show, format: :json, id: @item_one.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(2).to eq(json_response[:quantity])
      expect("12345.0").to eq(json_response[:unit_price])
    end
  end

  describe "GET #find" do
    before do
      InvoiceItem.create!(quantity: 2, unit_price: 12345)
      InvoiceItem.create!(quantity: 4, unit_price: 54321)
      InvoiceItem.create!(quantity: 2, unit_price: 2345)
    end

    it "responds with 200 success" do
      get :find, format: :json, quantity: 4

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoice item with quantity" do
      get :find, format: :json, quantity: 2

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(2).to eq(json_response[:quantity])
    end

    it "returns the correct invoice item with unit price" do
      get :find, format: :json, unit_price: 12345
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect("12345.0").to eq(json_response[:unit_price])
    end
  end

  describe "GET #find_all" do
    before do
      InvoiceItem.create!(quantity: 2, unit_price: 12345)
      InvoiceItem.create!(quantity: 4, unit_price: 54321)
      InvoiceItem.create!(quantity: 2, unit_price: 2345)
    end

    it "responds with 200 success" do
      get :find_all, format: :json, quantity: 4

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct invoice items with quantity" do
      get :find_all, format: :json, quantity: 2
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
    end
  end

  describe "GET #random" do
    before do
      InvoiceItem.create!(quantity: 2, unit_price: 12345)
      InvoiceItem.create!(quantity: 4, unit_price: 54321)
      InvoiceItem.create!(quantity: 2, unit_price: 2345)
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random invoice item" do
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

  describe "GET #invoice" do
    before do
      @invoice      = Invoice.create!(status: "shipped")
      @invoice_item = InvoiceItem.create!(invoice_id: @invoice.id, quantity: 2, unit_price: 12345)
    end

    it "responds with 200 success" do
      get :invoice, format: :json, id: @invoice_item.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated invoice" do
      get :invoice, format: :json, id: @invoice_item.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:id]).to eq(@invoice.id)
    end
  end

  describe "GET #item" do
    before do
      @item         = Item.create!(name: "item", description: "awesome", unit_price: 12345)
      @invoice_item = InvoiceItem.create!(item_id: @item.id, quantity: 2, unit_price: 12345)
    end

    it "responds with 200 success" do
      get :item, format: :json, id: @invoice_item.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated item" do
      get :item, format: :json, id: @invoice_item.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:id]).to eq(@item.id)
    end
  end
end
