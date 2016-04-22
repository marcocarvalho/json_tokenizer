require './pascal_base'

class PascalPreDeclaration < PascalBase
  def classes
    klass(name, declaration).flatten.compact.uniq
  end

  def array?(hash)
    hash[:array] && hash[:array].is_a?(Hash)
  end

  def klass?(hash)
    hash.is_a?(Hash) && !hash[:array]
  end

  def klass(name, hash)
    return nil unless hash.is_a?(Hash)
    hash.flat_map do |key, value|
      if key == :array
        klass(name, value)
      else klass?(hash)
        [ t_name(name), klass(key, value) ]
      end
    end
  end

  def template
    classes.map { |klass| "#{klass} = class;" }.join("\n  ")
  end

  alias_method :to_s, :template
end
