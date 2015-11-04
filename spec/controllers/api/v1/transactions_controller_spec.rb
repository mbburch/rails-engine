require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe "GET #index" do
    it "responds with 200 success" do
      get :index, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct number of transactions" do
      Transaction.create!(credit_card_number: "1234123412341234", result: "success")
      Transaction.create!(credit_card_number: "4321432143214321", result: "failed")
      Transaction.create!(credit_card_number: "1234567812345678", result: "success")

      number_of_transactions = Transaction.count

      get :index, format: :json

      json_response = JSON.parse(response.body)

      expect(number_of_transactions).to eq(json_response.count)
    end
  end

  describe "GET #show" do
    before do
      @transaction = Transaction.create!(credit_card_number: "1234123412341234", result: "success")
      Transaction.create!(credit_card_number: "4321432143214321", result: "failed")
      Transaction.create!(credit_card_number: "1234567812345678", result: "success")
    end

    it "responds with 200 success" do
      get :show, format: :json, id: @transaction.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct transaction" do
      get :show, format: :json, id: @transaction.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect("1234123412341234").to eq(json_response[:credit_card_number])
    end
  end

  describe "GET #find" do
    before do
      Transaction.create!(credit_card_number: "1234123412341234", result: "success")
      @transaction = Transaction.create!(credit_card_number: "4321432143214321", result: "failed")
      Transaction.create!(credit_card_number: "1234567812345678", result: "success")
    end

    it "responds with 200 success" do
      get :find, format: :json, result: "success"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct transaction with credit card number" do
      get :find, format: :json, credit_card_number: "4321432143214321"

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(@transaction.id).to eq(json_response[:id])
    end
  end

  describe "GET #find_all" do
    before do
      Transaction.create!(credit_card_number: "1234123412341234", result: "success")
      Transaction.create!(credit_card_number: "4321432143214321", result: "failed")
      Transaction.create!(credit_card_number: "1234567812345678", result: "success")
    end

    it "responds with 200 success" do
      get :find_all, format: :json, result: "success"

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct transactions with result" do
      get :find_all, format: :json, result: "success"
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.count).to eq(2)
    end
  end

  describe "GET #random" do
    before do
      Transaction.create!(credit_card_number: "1234123412341234", result: "success")
      Transaction.create!(credit_card_number: "4321432143214321", result: "failed")
      Transaction.create!(credit_card_number: "1234567812345678", result: "success")
    end

    it "responds with 200 success" do
      get :random, format: :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns a random transaction" do
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
      @invoice     = Invoice.create!(status: "shipped")
      @transaction = Transaction.create!(invoice_id: @invoice.id, credit_card_number: "1234123412341234", result: "success")
    end

    it "responds with 200 success" do
      get :invoice, format: :json, id: @transaction.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the associated invoice" do
      get :invoice, format: :json, id: @transaction.id

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:id]).to eq(@invoice.id)
    end
  end
end
