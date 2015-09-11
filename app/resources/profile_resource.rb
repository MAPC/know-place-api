class ProfileResource < JSONAPI::Resource
  has_one :place
  has_one :report

  attributes :title, :complete, :evaluation

  filters :complete

  def self.apply_filter(records, filter, value, options)
    case filter
    when :complete
      return records.complete
    else
      return super(records, filter, value)
    end
  end


  def self.updatable_fields(context)
    super - [:title]
  end

  def self.creatable_fields(context)
    super - [:title]
  end
end
