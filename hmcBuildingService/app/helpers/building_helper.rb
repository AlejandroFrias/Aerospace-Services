module BuildingHelper
  def plist_type (value)
    case value
    when Fixnum
      "integer"
    when String
      "string"
    else
      "real"
    end
  end
end
