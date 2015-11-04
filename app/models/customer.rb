class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :transactions, through: :invoices

  def favorite_merchant
    id = invoices.successful.group_by(&:merchant_id).sort_by { |key, val| val.count }.reverse.flatten.first
    Merchant.find_by(id: id)
  end
end
