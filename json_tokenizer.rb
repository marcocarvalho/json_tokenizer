require 'json'

class JsonTokenizer
  attr_accessor :filename
  def initialize(filename)
    @filename = filename
  end

  def json
    @json ||= JSON.parse(File.read(filename))
  end

  def object(obj)
    obj.each_with_object({}) do |(key, value), hash|
      hash[key] = decide(value)
    end
  end

  def array(obj)
    _obj = obj.flat_map do |o|
      decide(o)
    end.compact.uniq.first
    { array: _obj }
  end

  def decide(obj)
    if obj.is_a?(Array)
      array(obj)
    elsif obj.is_a?(Hash)
      object(obj)
    else
      pascal_type(obj.class)
    end
  end

  def pascal_type(klass)
    k = klass.to_s
    case k
    when 'Fixnum'
      'Integer'
    when 'Float'
      'Double'
    when 'TrueClass'
      'Boolean'
    when 'FalseClass'
      'Boolean'
    else
      k
    end
  end

  def parse
    decide(json)
  end
end
