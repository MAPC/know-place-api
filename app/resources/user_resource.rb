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

  def self.fetchable_fields
    super - [:password, :token]
  end

end
