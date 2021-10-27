class MerchantRevenueSerializer
  include JSONAPI::Serializer
  attributes :revenue
  set_id :merchant_id
end
