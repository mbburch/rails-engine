class Api::V1::CustomersController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with Customer.all
  end

  def show
    respond_with Customer.find_by(id: params[:id])
  end

  def find
    respond_with Customer.find_by(search_params)
  end

  def find_all
    respond_with Customer.where(search_params)
  end

  def random
    respond_with Customer.limit(1).order("RANDOM()")
  end

  def invoices
    respond_with Customer.find_by(search_params).invoices
  end

  def transactions
    respond_with Customer.find_by(search_params).transactions
  end

  def favorite_merchant
    respond_with Customer.find_by(search_params).favorite_merchant
  end

  private

  def search_params
    params.permit(:id,
                  :first_name,
                  :last_name,
                  :updated_at,
                  :created_at)
  end
end
