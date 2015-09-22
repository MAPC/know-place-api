class PlaceResource < JSONAPI::Resource
  attributes :name, :municipality, :description, :tags, :geometry,
             :completed, :underlying, :geoids, :current_user

  filters :search

  def current_user
    context && context[:current_user]
  end

  def self.apply_filter(records, filter, value, options)
    case filter
    when :search
      q = value.first
      return q ? records.search(q) : records
    else
      return super(records, filter, value)
    end
  end

  def self.updatable_fields(context)
    super - [:underlying, :municipality]
  end

  def self.creatable_fields(context)
    super - [:underlying, :municipality]
  end
end
