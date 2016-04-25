require './pascal_base'

class PascalTypeDeclaration < PascalBase
  attr_accessor :opts

  def initialize(name, declaration, opts = {})
    super(name, declaration)
    @opts = opts
  end

  def private_part
    declaration.map do |field, type|
      if field == :array && type.is_a?(Hash)
        "#{f_key(name)}: #{array_type(name)};"
      elsif field != :array && type.is_a?(Hash) && type[:array]
        "#{f_key(field)}: #{array_type(field)};"
      else
        "#{f_key(field)}: #{type}"
      end
    end.join("\n    ")
  end

  def public_part
    declaration.map do |field, type|
      if field == :array && type.is_a?(Hash)
        "#{name}: #{array_type(name)} read #{f_key(name)} write #{f_key(name)};"
      elsif field != :array && type.is_a?(Hash)
        "#{field}: #{array_type(field)} read #{f_key(field)} write #{f_key(field)};"
      else
        "property #{field}: #{type} read #{f_key(field)} write #{f_key(field)};"
      end
    end.join("\n    ")
  end

  def class_name
    if opts[:first]
      t_collection(name)
    else
      super
    end
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
