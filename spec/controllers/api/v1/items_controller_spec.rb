require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of items" do
      Item.create!(name: "item", description: "awesome", unit_price: 12345)
      Item.create!(name: "item two", description: "cool", unit_price: 54321)

      number_of_items = Item.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_items).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @item = Item.create!(name: "item", description: "awesome", unit_price: 12345)
      Item.create!(name: "item two", description: "cool", unit_price: 54321)
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @item.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct item" do
      get :show, format: :json, id: @item.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect("item").to eq(json_response[:name])
      expect("awesome").to eq(json_response[:description])
    end
  end

  describe "GET #find" do
    before do
      Item.create!(name: "item", description: "awesome", unit_price: 12345)
      Item.create!(name: "item two", description: "cool", unit_price: 54321)
    end

    it "responds with 200 success" do
      get :find, format: :json, name: "item two"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct item with description" do
      get :find, format: :json, description: "cool"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect("cool").to eq(json_response[:description])
    end
  end

  describe "GET #find_all" do
    before do
      Item.create!(name: "item", description: "awesome", unit_price: 12345)
      Item.create!(name: "item two", description: "cool", unit_price: 54321)
    end

    it "responds with 200 success" do
      get :find_all, format: :json, name: "item"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct items with name" do
      get :find_all, format: :json, name: "item"
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(1)
    end
  end

  describe "GET #random" do
    before do
      Item.create!(name: "item", description: "awesome", unit_price: 12345)
      Item.create!(name: "item two", description: "cool", unit_price: 54321)
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random item" do
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

  describe "GET #invoice_items" do
    before do
      @item = Item.create!(name: "item", description: "awesome", unit_price: 12345)
      InvoiceItem.create!(item_id: @item.id, quantity: 2, unit_price: 12345)
      InvoiceItem.create!(item_id: @item.id, quantity: 2, unit_price: 2345)
    end

    it "responds with 200 success" do
      get :invoice_items, format: :json, id: @item.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated invoice items" do
      get :invoice_items, format: :json, id: @item.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response.count).to eq(2)
      expect(json_response.first[:item_id]).to eq(@item.id)
    end
  end

  describe "GET #merchant" do
    before do
      @merchant = Merchant.create!(name: "Merchant One")
      @item     = Item.create!(merchant_id: @merchant.id, name: "item", description: "awesome", unit_price: 12345)
    end

    it "responds with 200 success" do
      get :merchant, format: :json, id: @item.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns associated merchant" do
      get :merchant, format: :json, id: @item.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:id]).to eq(@merchant.id)
    end
  end
end
