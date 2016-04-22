require './normalizator'

class PascalBase
  include Normalizator

  attr_accessor :declaration, :name, :opts
  def initialize(name, hash, opts = {})
    @declaration = hash
    @name        = name
    @opts        = opts
  end
end
