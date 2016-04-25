require './pascal_base'

class PascalPreDeclaration < PascalBase
  def classes
    klass(name, declaration, first: true).flatten.compact.uniq
  end

  def array?(hash)
    hash[:array] && hash[:array].is_a?(Hash)
  end

  def klass?(hash)
    hash.is_a?(Hash) && !hash[:array]
  end

  def klass(name, hash, opts = {})
    return nil unless hash.is_a?(Hash)
    hash.flat_map do |key, value|
      if key == :array
        [ opts[:first] ? t_collection(name) : nil, klass(name, value) ]
      else klass?(hash)
        [ t_name(name), klass(key, value) ]
      end
    end
  end

  def template
    "type \n  " +
    classes.map { |klass| "#{klass} = class;" }.join("\n  ")
  end

  alias_method :to_s, :template
end
