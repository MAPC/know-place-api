module API
  module V1
    class UserResource < JSONAPI::Resource

      attributes :email, :password, :token

      has_many :places
      has_many :profiles

      # after_create do
      #   sign_in @model, store: false
      # end

      def self.creatable_fields(context)
        super - [:token]
      end

      def self.updatable_fields(context)
        super - [:token]
      end

      def fetchable_fields
        if (context[:current_user] == @model)
          super - [:password]
        else
          super - [:password, :token]
        end
      end

    end
  end
end
