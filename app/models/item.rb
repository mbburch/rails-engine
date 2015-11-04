class Item < ActiveRecord::Base
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  default_scope { order(:id) }

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
    date_quantity = invoices.successful.group('invoices.created_at').sum('quantity')
    { best_day: date_quantity.sort_by { |key, val| val }.reverse.flatten.first }
  end
end
