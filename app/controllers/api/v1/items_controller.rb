class Api::V1::ItemsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with Item.all
  end

  def show
    respond_with Item.find_by(id: params[:id])
  end

  def find
    respond_with Item.find_by(search_params)
  end

  def find_all
    respond_with Item.where(search_params)
  end

  def random
    respond_with Item.limit(1).order("RANDOM()")
  end

  def invoice_items
    respond_with Item.find_by(id: search_params[:item_id]).invoice_items
  end

  def merchant
    respond_with Item.find_by(id: search_params[:item_id]).merchant
  end

  private

  def search_params
    params.permit(:id,
                  :name,
                  :description,
                  :unit_price,
                  :merchant_id,
                  :updated_at,
                  :created_at,
                  :item_id)
  end
end
