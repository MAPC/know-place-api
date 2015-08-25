class ProfileSerializer < ApplicationSerializer
  has_one :place
  has_one :report

  def id
    object.to_param.to_s
  end

  attribute :title do
    object.title
  end
end