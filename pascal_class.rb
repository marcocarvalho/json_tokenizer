class PascalClass
  attr_accessor :name, :object, :opts
  def initialize(name, object, opts = {})
    @object = object
    @name   = name.to_s
    @opts   = opts
  end

  def f_key(str)
    "f"+str.to_s.capitalize
  end

  def private_part(default_ident = '    ')
    object.map do |key, value|
      if value.is_a?(Hash)
        "#{f_key(key)}: #{array_type(key)};"
      else
        "#{f_key(key)}: #{value};"
      end
    end.join("\n#{default_ident}")
  end

  def array_type(name)
    "TArray#{t_name(name)}"
  end

  def array_types
    object.select { |_, value| value.is_a?(Hash) }.map do |key, value|
      if(value.values.first.is_a?(String))
        "type #{array_type(key)} = array of #{value.values.first};"
      else
        "type #{array_type(key)} = array of #{t_name(key)};"
      end
    end
  end

  def public_part(default_ident = '    ')
    object.map do |key, value|
      if value.is_a?(Hash)
        "property #{key}: #{array_type(key)} read #{f_key(key)} write #{f_key(key)};"
      else
        "property #{key}: #{value} read #{f_key(key)} write #{f_key(key)};"
      end
    end.join("\n#{default_ident}")
  end

  def custom_types
    array_types.join("\n");
  end

  def uses
    return '' unless opts[:dependencies].is_a?(Array) && opts[:dependencies].count > 0
    "uses " + opts[:dependencies].join(', ') + ";\n"
  end

  def implementation
    v = <<Pascal
constructor #{class_name}.create();
begin
end;
Pascal
  end

  def t_name(n)
    "T#{n.capitalize}"
  end

  def class_name
    t_name(name)
  end

  def template
    v = <<PASCAL
{$mode objfpc}
{$m+}

unit #{name};

interface

#{uses}

#{custom_types}

type #{class_name} = class
  private
    #{private_part}

  public
    constructor create();
    #{public_part}
end;

implementation

#{implementation}

end.
PASCAL
  end
end
