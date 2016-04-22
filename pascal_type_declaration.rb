require './pascal_base'

class PascalTypeDeclaration < PascalBase
  def private_part
    declaration.map do |field, type|
      if field == :array && type.is_a?(Hash)
        "#{f_key(name)}: #{array_type(name)};"
      elsif type.is_a?(Hash) && type[:array]
        "#{f_key(field)}: #{array_type(field)};"
      else
        "#{f_key(field)}: #{type}"
      end
    end.join("\n    ")
  end

  def public_part
    declaration.map do |field, type|
      "property #{field}: #{type} read #{f_key(field)} write #{f_key(field)};"
    end.join("\n    ")
  end

  def template
    v = <<Pascal
#{class_name} = class
  private
    #{private_part}
    procedure populate(value: TJSONValue);

  public
    constructor create(value: String) overload;
    constructor create(value: TJSONValue) overload;
    #{public_part}
end;
Pascal
  end

  alias_method :to_s, :template
end
