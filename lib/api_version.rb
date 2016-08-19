class APIVersion

  attr_reader :version, :default

  def initialize(version: , default: false)
    @version = version.to_i
    @default = default
  end

  def params
    {
      module:    module_name,
      header:    header,
      parameter: parameter,
      default:   @default
    }
  end

  private

  def module_name
    "V#{@version}"
  end

  def header
    {
      name:  "Accept",
      value: "application/vnd.api+json; application/org.dd.v#{@version}"
    }
  end

  def parameter
    { name: "version", value: @version.to_s }
  end

end
