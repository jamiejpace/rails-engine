class MerchantNameRevenueSerializer
  def self.new(merchants)
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
end
