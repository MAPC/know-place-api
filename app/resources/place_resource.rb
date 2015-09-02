class PlaceResource < JSONAPI::Resource
  attributes :name, :description, :geometry, :completed, :underlying, :geoids

  def self.updatable_fields(context)
    super - [:underlying]
  end

  def self.creatable_fields(context)
    super - [:underlying]
  end
end
