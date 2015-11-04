require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of customers" do
      Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")

      number_of_customers = Customer.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_customers).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @custy_one = Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")
      Customer.create!(first_name: "Josh", last_name: "Cheek")
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @custy_one.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct customer" do
      get :show, format: :json, id: @custy_one.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect("Josh").to eq(json_response[:first_name])
      expect("Mejia").to eq(json_response[:last_name])
    end
  end

  describe "GET #find" do
    before do
      Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")
      Customer.create!(first_name: "Josh", last_name: "Cheek")
    end

    it "responds with 200 success" do
      get :find, format: :json, last_name: "Tellez"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct customer with first name" do
      get :find, format: :json, first_name: "Josh"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect("Josh").to eq(json_response[:first_name])
    end

    it "returns the correct customer with case insensitive last name" do
      get :find, format: :json, last_name: "mEjIa"
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect("Mejia").to eq(json_response[:last_name])
    end
  end

  describe "GET #find_all" do
    before do
      Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")
      Customer.create!(first_name: "Josh", last_name: "Cheek")
    end

    it "responds with 200 success" do
      get :find_all, format: :json, first_name: "Josh"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct customers with first name" do
      get :find_all, format: :json, first_name: "Josh"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
    end
  end

  describe "GET #random" do
    before do
      Customer.create!(first_name: "Josh", last_name: "Mejia")
      Customer.create!(first_name: "Jorge", last_name: "Tellez")
      Customer.create!(first_name: "Josh", last_name: "Cheek")
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random customer" do
      @results = []

      5.times do
        get :random, format: :json
        response_one = JSON.parse(response.body, symbolize_names: true)
        get :random, format: :json
        response_two = JSON.parse(response.body, symbolize_names: true)

        @results << (response_one == response_two)
      end
      expect(@results.include?(false)).to eq true
    end
  end

  describe "GET #invoices" do
    before do
      @custy_one = Customer.create!(first_name: "Josh", last_name: "Mejia")
      Invoice.create!(customer_id: @custy_one.id, status: "shipped")
      Invoice.create!(customer_id: @custy_one.id, status: "shipped")
    end

    it "responds with 200 success" do
      get :invoices, format: :json, id: @custy_one.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all customer invoices" do
      get :invoices, format: :json, id: @custy_one.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:customer_id]).to eq(@custy_one.id)
    end
  end

  describe "GET #transactions" do
    before do
      @custy_one   = Customer.create!(first_name: "Josh", last_name: "Mejia")
      @invoice_one = Invoice.create!(customer_id: @custy_one.id, status: "shipped")
      @invoice_two = Invoice.create!(customer_id: @custy_one.id, status: "shipped")
      Transaction.create!(invoice_id: @invoice_one.id, credit_card_number: "1234123412341234", result: "success")
      Transaction.create!(invoice_id: @invoice_two.id, credit_card_number: "4321432143214321", result: "failed")
    end

    it "responds with 200 success" do
      get :transactions, format: :json, id: @custy_one.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns all customer transactions" do
      get :transactions, format: :json, id: @custy_one.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
      expect(json_response.first[:invoice_id]).to eq(@invoice_one.id)
    end
  end
end
