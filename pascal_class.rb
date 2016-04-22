require './normalizator'
require './pascal_custom_type'
require './pascal_implementation'
require './pascal_pre_declaration'
require './pascal_type_declaration'

class PascalClass
  include Normalizator

  attr_accessor :name, :declaration, :opts
  def initialize(name, declaration, opts = {})
    @declaration = declaration
    @name        = name.to_s
    @opts        = opts
    @opts[:dependencies] ||= []
    add_default_dependencies
  end

  def add_default_dependencies
    opts[:dependencies].push('System.Json')     unless @opts[:dependencies].include?('System.Json')
    opts[:dependencies].push('System.SysUtils') unless @opts[:dependencies].include?('System.SysUtils')
    opts[:dependencies].push('System.Classes')  unless @opts[:dependencies].include?('System.Classes')
  end

  def interface
    [uses, pre_declaration, custom_types, type_declaration].compact.join("\n\n")
  end

  def uses
    return nil unless opts[:dependencies].is_a?(Array) && opts[:dependencies].count > 0
    "uses " + opts[:dependencies].join(', ') + ";\n"
  end

  def pascal_custom_type
  end

  def template
    v = <<PASCAL
unit #{name};

interface

#{interface}

implementation

#{implementation}

end.
PASCAL
  end
end
