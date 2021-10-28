class ItemRevenueSerializer
  def self.new(items)
    {
      "data": items.map do |i|
        {
          "id": i.id.to_s,
          "type": "item_revenue",
          "attributes": {
            "name": i.name,
            "description": i.description,
            "unit_price": i.unit_price,
            "merchant_id": i.merchant_id,
            "revenue": i.revenue.to_f
          }
        }
    end
    }
  end

end
