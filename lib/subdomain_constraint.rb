class SubdomainConstraint
  def initialize(subdomain)
    @subdomain = subdomain
  end

  def matches?(request)
    @subdomain.match request.host
  end
end
