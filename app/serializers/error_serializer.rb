class ErrorSerializer
  include JSONAPI::Serializer
  attributes :error_message, :status, :code
end
