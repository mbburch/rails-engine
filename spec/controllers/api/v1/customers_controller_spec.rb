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

    it "responds with 200 success" do
      custy_one = Customer.create!(first_name: "Josh", last_name: "Mejia")
      custy_two = Customer.create!(first_name: "Jorge", last_name: "Tellez")

      customer = custy_one

      get :show, format: :json, id: customer.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns the correct customer" do
      custy_one = Customer.create!(first_name: "Josh", last_name: "Mejia")
      custy_two = Customer.create!(first_name: "Jorge", last_name: "Tellez")

      customer = custy_one

      get :show, format: :json, id: customer.id

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(customer.first_name).to eq(json_response[:first_name])
      expect(customer.last_name).to eq(json_response[:last_name])
    end
  end
end

