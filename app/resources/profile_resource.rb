class ProfileResource < JSONAPI::Resource

  has_one :place
  has_one :report
  has_one :user

  attributes :title, :complete, :evaluation

  filters :complete

  # TODO: Update JR, move to new syntax.
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
