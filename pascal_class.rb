class PascalClass
  attr_accessor :name, :object
  def initialize(name, object)
    @object = object
    @name   = name.to_s
  end

  def f_key(str)
    "f"+str.to_s.capitalize
  end

  def private_part(default_ident = '    ')
    object.map do |key, value|
      if value.is_a?(Hash)
        "#{f_key(key)}: array of #{t_name(key)};"
      else
        "#{f_key(key)}: #{value};"
      end
    end.join("\n#{default_ident}")
  end

  def public_part(default_ident = '    ')
    object.map do |key, value|
      if value.is_a?(Hash)
        "property #{key}:array of #{t_name(key)} read #{f_key(key)} write #{f_key(key)};"
      else
        "property #{key}:#{value} read #{f_key(key)} write #{f_key(key)};"
      end
    end.join("\n#{default_ident}")
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
