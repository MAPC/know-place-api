class UserResource < JSONAPI::Resource
  attributes :email, :password, :token

  has_many :places
  has_many :profiles

  def self.creatable_fields(context)
    super - [:token]
  end

  def self.updatable_fields(context)
    super - [:token]
  end

  def fetchable_fields
    if context[:action] == "show"
      super - [:password, :token]
    else
      super - [:password]
    end
  end

end
