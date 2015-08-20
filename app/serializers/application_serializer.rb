require 'jsonapi-serializers'
class ApplicationSerializer
  include JSONAPI::Serializer

  def format_name(attribute_name)
    attribute_name.to_s.underscore
  end
end