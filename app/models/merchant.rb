class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.find_merchant_by_name(name)
    where("name ILIKE ?", "%#{name}%")
    .order("LOWER(name)")
  end

  def self.most_items_sold(quantity = 5)
    joins(items: {invoice_items: {invoice: :transactions}})
    .select("merchants.*, SUM(invoice_items.quantity) AS count")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("count desc")
    .limit(quantity)
  end

  def self.top_revenue(quantity)
    joins(items: {invoice_items: {invoice: :transactions}})
    .select("merchants.*, cast(SUM(invoice_items.unit_price * invoice_items.quantity) as decimal(100,2)) AS revenue")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("revenue desc")
    .limit(quantity)
  end

  def self.find_merchant_revenue(merchant_id)
    joins(items: {invoice_items: {invoice: :transactions}})
    .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .where("transactions.result = ? AND merchants.id = ?", "success", merchant_id)
    .group("merchants.id")
    .first
  end
end
