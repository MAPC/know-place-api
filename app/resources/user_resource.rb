class UserResource < JSONAPI::Resource
  attributes :email, :password, :token


  def self.creatable_fields(context)
    super - [:token]
  end

  def self.updatable_fields(context)
    super - [:token]
  end

end
