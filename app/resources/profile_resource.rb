class ProfileResource < JSONAPI::Resource
  attribute :title

  def self.updatable_fields(context)
    super - [:title]
  end

  def self.creatable_fields(context)
    super - [:title]
  end

  has_one :place
  has_one :report
end
