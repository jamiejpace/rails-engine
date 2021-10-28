class Item < ApplicationRecord
  validates_presence_of :name
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  validates :merchant_id, presence: true

  def self.all_items_for_merchant(id)
    where(merchant_id: id)
  end

  def self.find_items_by_name(name)
    where("name ILIKE ?", "%#{name}%")
    .order(:name)
  end

  def self.find_items_by_price(min, max)
    if max && !min
      where('unit_price < ?', max)
    elsif min && !max
      where('unit_price > ?', min)
    else
      where('unit_price < ? AND unit_price > ?', max, min)
    end
  end

  def self.by_top_revenue(quantity = 10)
    joins(invoice_items: {invoice: :transactions})
    .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .where("transactions.result = ?", "success")
    .group("items.id")
    .order("revenue desc")
    .limit(quantity)
  end
end
