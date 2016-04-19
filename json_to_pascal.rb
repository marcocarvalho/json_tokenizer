require './json_tokenizer'
require './pascal_class'
require 'byebug'

class CreatePascalClasses
  attr_accessor :json_file
  def initialize(json_file)
    @json_file = json_file
  end

  def create_class(name, hash)
    puts "- #{name}.pas"
    hash.select do |_, v|
      puts _, v, dependency?(v)
      dependency?(v)
    end.each do |key, value|
      print " Dependency: "
      param = value[:array] ? value[:array] : value
      create_class(key, param)
    end
    File.open("#{name}.pas",'w+') do |f|
      f.write PascalClass.new(name, hash).template
    end
  end

  def dependency?(value)
  (
    value.is_a?(Hash) &&
    value.keys.first != :array
  ) || (
    value.is_a?(Hash) &&
    value.keys.first == :array &&
    !value.values.first.is_a?(String)
  )
  end

  def create
    create_class(File.basename(json_file), tokenized)
  end

  def tokenized
    return @tokenized if @tokenized
    @tokenized = JsonTokenizer.new(json_file).parse

    # se o Root é um array, ignora essa primeira chave
    if @tokenized[:array]
      @tokenized = @tokenized[:array]
    end

    @tokenized
  end
end

ARGV.each do |file|
  CreatePascalClasses.new(file).create
end
