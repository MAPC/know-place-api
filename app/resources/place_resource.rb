class PlaceResource < JSONAPI::Resource
  attributes :name, :description, :geometry, :completed
end
