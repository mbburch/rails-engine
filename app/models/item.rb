class Item < ActiveRecord::Base
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  def self.most_revenue(quantity)
    all.max_by(quantity.to_i) { |item| item.revenue[:revenue] }
  end

  def self.most_items(quantity)
    all.max_by(quantity.to_i) { |item| item.item_quantity }
  end

  def revenue
    { revenue: invoices.successful.sum("invoice_items.unit_price * invoice_items.quantity") }
  end

  def item_quantity
    invoices.successful.sum("invoice_items.quantity")
  end

  def best_day
    { best_day: invoices.successful.group('invoices.created_at').sum('quantity').sort_by { |key, val| val }.reverse.flatten.first }
  end
end
