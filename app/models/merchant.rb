class Merchant < ActiveRecord::Base
  has_many :invoices
  has_many :items

  def favorite_customer
    id = invoices.successful.group_by(&:customer_id).sort_by { |key, val| val.count }.reverse.flatten.first
    Customer.find_by(id: id)
  end

  def customers_with_pending_invoices
    invoices.pending.map do |invoice|
      invoice.customer
    end.uniq
  end

  def self.most_revenue(quantity)
    all.max_by(quantity.to_i) { |merchant| merchant.merchant_revenue[:revenue] }
  end

  def self.most_items(quantity)
    all.max_by(quantity.to_i) { |merchant| merchant.merchant_item_quantity }
  end

  def self.total_revenue(date)
      { total_revenue: Invoice.all.successful.where(created_at: date).joins(:invoice_items).sum("quantity * unit_price") }
  end

  def merchant_revenue
    { revenue: invoices.successful.joins(:invoice_items).sum("unit_price * quantity") }
  end

  def revenue_by_date(date)
    { revenue: invoices.successful.where(invoices: { created_at: date }).joins(:invoice_items).sum("unit_price * quantity") }
  end

  def merchant_item_quantity
    invoices.successful.joins(:invoice_items).sum("quantity")
  end
end
