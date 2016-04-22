require './normalizator'

class PascalBase
  include Normalizator

  attr_accessor :declaration, :name
  def initialize(name, hash)
    @declaration = hash
    @name        = name
  end
end
