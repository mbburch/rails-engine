class Api::V1::MerchantsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with Merchant.all
  end

  def show
    respond_with Merchant.find_by(id: params[:id])
  end

  def find
    respond_with Merchant.find_by(search_params)
  end

  def find_all
    respond_with Merchant.where(search_params)
  end

  def random
    respond_with Merchant.limit(1).order("RANDOM()")
  end

  def items
    respond_with Merchant.find_by(search_params).items
  end

  def invoices
    respond_with Merchant.find_by(search_params).invoices
  end

  private

  def search_params
    params.permit(:id,
                  :name,
                  :updated_at,
                  :created_at)
  end
end
