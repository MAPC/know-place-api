module API
  module V1
    class UserResource < JSONAPI::Resource

      attributes :email, :password, :token

      has_many :places
      has_many :profiles

      # def self.creatable_fields(context)
      #   super - [:token]
      # end

      # def self.updatable_fields(context)
      #   super - [:token]
      # end

      def fetchable_fields
        super - [:token, :password]
      end

    end
  end
end
