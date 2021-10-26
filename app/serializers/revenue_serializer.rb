class RevenueSerializer
  def self.merchant_name_revenue(merchants)
    {
      "data": merchants.map do |m|
        {
          "id": m.id.to_s,
          "type": "merchant_name_revenue",
          "attributes": {
            "name": m.name,
            "revenue": m.revenue.to_f.round(2)
          }
        }
    end
    }
  end

  def self.merchant_revenue(merchant)
    {
      "data":
        {
          "id": merchant.id.to_s,
          "type": "merchant_revenue",
          "attributes": {
            "revenue": merchant.revenue
          }
        }
    }
  end


end
