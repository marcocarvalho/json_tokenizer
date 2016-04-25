require './pascal_base'

class PascalTypeDeclaration < PascalBase
  attr_accessor :opts

  def initialize(name, declaration, opts = {})
    super(name, declaration)
    @declaration = @declaration.select { |_,v| v && v != '' }
    @opts = opts
  end

  def private_part
    declaration.map do |field, type|
      next if unwanted_attributes(field, type)
      if field == :array && type.is_a?(Hash)
        n = collection_class? ? extract_collection_name : name
        "#{f_key(n)}: #{array_type(n)};"
      elsif field != :array && type.is_a?(Hash) && type[:array]
        "#{f_key(field)}: #{array_type(field)};"
      elsif field != :array && type.is_a?(Hash) && !type[:array]
        "#{f_key(field)}: #{t_name(field)};"
      else
        "#{f_key(field)}: #{type};"
      end
    end.join("\n    ")
  end

  def property_name(name)
    "property #{p_key(name)}"
  end

  def property_value_array(name)
    "#{array_type(name)} read #{f_key(name)} write #{f_key(name)}"
  end

  def property_value_object(name)
    "#{t_name(name)} read #{f_key(name)} write #{f_key(name)}"
  end

  def property_value(field, type)
    "#{type} read #{f_key(field)} write #{f_key(field)}"
  end

  def public_part
    declaration.map do |field, type|
      next if unwanted_attributes(field, type)
      pn = property_name(field)
      if field == :array && type.is_a?(Hash)
        pn = collection_class? ? "property #{extract_collection_name}" : property_name(name)
        pv = property_value_array(collection_class? ? extract_collection_name : name)
      elsif field != :array && type.is_a?(Hash) && type[:array]
        pv = property_value_array(field)
      elsif field != :array && type.is_a?(Hash) && !type[:array]
        pv = property_value_object(field)
      else
        pv = property_value(field, type)
      end
      "#{pn}: #{pv};"
    end.join("\n    ")
  end

  def class_name
    name
  end

  def template
    return '' if declaration.empty?
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
