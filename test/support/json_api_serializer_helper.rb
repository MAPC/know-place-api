module JsonApiSerializerHelper
  def serializer
    @serializer ||= JSONAPI::Serializer
  end

  def serialization
    @object ||= serializer.serialize( resource, is_collection: false )
  end

  alias_method :s, :serialization

  def data
    serialization["data"]
  end

  def attributes
    data["attributes"]
  end
end