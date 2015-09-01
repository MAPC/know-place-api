class DataPointResource < JSONAPI::Resource
  attribute :name

  def evaluation
    { value: nil, margin: nil }
  end

  def self.updatable_fields(context)
    super - [:evaluation]
  end

  def self.creatable_fields(context)
    super - [:evaluation]
  end
end
