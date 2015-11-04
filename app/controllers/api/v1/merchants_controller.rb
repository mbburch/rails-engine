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

  def most_revenue
    respond_with Merchant.most_revenue(params[:quantity])
  end

  def most_items
    respond_with Merchant.most_items(params[:quantity])
  end

  def revenue_by_date
    respond_with Merchant.total_revenue(params[:date])
  end

  def individual_revenue
    if params[:date]
      respond_with Merchant.find_by(search_params).revenue_by_date(params[:date])
    else
      respond_with Merchant.find_by(search_params).merchant_revenue
    end
  end


  def favorite_customer
    respond_with Merchant.find_by(search_params).favorite_customer
  end

  def customers_with_pending_invoices
    respond_with Merchant.find_by(search_params).customers_with_pending_invoices
  end


  private

  def search_params
    params.permit(:id,
                  :name,
                  :updated_at,
                  :created_at)
  end
end
