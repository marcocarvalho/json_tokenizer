require 'json'
require 'byebug'

class JsonTokenizer
  attr_accessor :filename
  def initialize(filename)
    @filename = filename
  end

  def json
    @json ||= JSON.parse(File.read(filename))
  end

  def object(obj)
    obj.map do |key, value|
      { key => decide(value) }
    end
  end

  def array(obj)
    obj.flat_map do |o|
      decide(o)
    end.compact.uniq
  end

  def decide(obj)
    if obj.is_a?(Array)
      array(obj)
    elsif obj.is_a?(Hash)
      object(obj)
    else
      obj.class
    end
  end

  def parse
    decide(json)
  end
end

ARGV.each do |file|
  jt = JsonTokenizer.new(file)
  puts jt.parse.to_json
end
