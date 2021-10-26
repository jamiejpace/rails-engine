class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.find_merchant_by_name(name)
    where("name ILIKE ?", "%#{name}%")
    .order("LOWER(name)")
    .first
  end

  def self.most_items_sold(quantity)
    joins(items: {invoice_items: {invoice: :transactions}})
    .select("merchants.*, SUM(invoice_items.quantity) AS count")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("count desc")
    .limit(quantity)
  end
end
