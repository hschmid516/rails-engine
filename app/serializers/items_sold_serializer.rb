class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name
  attribute :count do |object|
    object.item_count
  end
end
