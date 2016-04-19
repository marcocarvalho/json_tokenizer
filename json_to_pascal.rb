require './json_tokenizer'
require './pascal_class'

class CreatePascalClasses
  attr_accessor :json_file
  def initialize(json_file)
    @json_file = json_file
  end

  def create_class(name, hash)
    puts "- #{name}.pas"
    hash.select { |_, v| v.is_a?(Hash) }.each do |key, value|
      print " Dependency: "
      create_class(key, value)
    end
    File.open("#{name}.pas",'w+') do |f|
      f.write PascalClass.new(name, hash).template
    end
  end

  def create
    create_class(File.basename(json_file), tokenized)
  end

  def tokenized
    @tokenized ||= JsonTokenizer.new(json_file).parse
  end
end

ARGV.each do |file|
  CreatePascalClasses.new(file).create
end
