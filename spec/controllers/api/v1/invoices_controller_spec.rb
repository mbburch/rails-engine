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
end
