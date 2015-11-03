class Api::V1::InvoicesController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with Invoice.all
  end

  def show
    respond_with Invoice.find_by(id: params[:id])
  end

  def find
    respond_with Invoice.find_by(search_params)
  end

  def find_all
    respond_with Invoice.where(search_params)
  end

  def random
    respond_with Invoice.limit(1).order("RANDOM()")
  end

  def transactions
    respond_with Invoice.find_by(id: search_params[:invoice_id]).transactions
  end

  def invoice_items
    respond_with Invoice.find_by(id: search_params[:invoice_id]).invoice_items
  end

  def items
    respond_with Invoice.find_by(id: search_params[:invoice_id]).items
  end

  def customer
    respond_with Invoice.find_by(id: search_params[:invoice_id]).customer
  end

  def merchant
    respond_with Invoice.find_by(id: search_params[:invoice_id]).merchant
  end

  private

  def search_params
    params.permit(:id,
                  :status,
                  :merchant_id,
                  :customer_id,
                  :updated_at,
                  :created_at,
                  :invoice_id)
  end
end
