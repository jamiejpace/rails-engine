class MostItemsSerializer
  include JSONAPI::Serializer
  attributes :name, :count
end
