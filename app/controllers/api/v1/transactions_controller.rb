class Api::V1::TransactionsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find_by(id: params[:id])
  end

  def find
    respond_with Transaction.find_by(search_params)
  end

  def find_all
    respond_with Transaction.where(search_params)
  end

  def random
    respond_with Transaction.limit(1).order("RANDOM()")
  end

  def invoice
    respond_with Transaction.find_by(id: search_params[:transaction_id]).invoice
  end

  private

  def search_params
    params.permit(:id,
                  :invoice_id,
                  :credit_card_number,
                  :credit_card_expiration_date,
                  :result,
                  :updated_at,
                  :created_at,
                  :transaction_id)
  end
end
