class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with InvoiceItem.all
  end

  def show
    respond_with InvoiceItem.find_by(id: params[:id])
  end

  def find
    respond_with InvoiceItem.find_by(search_params)
  end

  def find_all
    respond_with InvoiceItem.where(search_params)
  end

  def random
    respond_with InvoiceItem.limit(1).order("RANDOM()")
  end

  private

  def search_params
    params.permit(:id,
                  :quantity,
                  :unit_price,
                  :item_id,
                  :invoice_id,
                  :updated_at,
                  :created_at)
  end
end
