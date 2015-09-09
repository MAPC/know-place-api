class PlaceResource < JSONAPI::Resource
  attributes :name, :description, :tags, :geometry, :completed,
             :underlying, :geoids

  filters :search

  def self.apply_filter(records, filter, value, options)
    case filter
    when :search
      return records.search(value.first)
    else
      return super(records, filter, value)
    end
  end

  def self.updatable_fields(context)
    super - [:underlying]
  end

  def self.creatable_fields(context)
    super - [:underlying]
  end
end
