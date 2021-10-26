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
end
