class Merchant < ActiveRecord::Base
  has_many :invoices
  has_many :items

  # def self.highest_total_revenue
  #   merchants = Merchant.all
  #   merchants.map do |merchant|
  #     [merchant.id, merchant.
  # end
end
