class Invoice < ActiveRecord::Base
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  belongs_to :customer
  belongs_to :merchant

  def self.successful
    Invoice.joins(:transactions).where(transactions: { result: "success" })
  end

  def self.pending
    Invoice.joins(:transactions).where(transactions: { result: "failed" })
  end
end
