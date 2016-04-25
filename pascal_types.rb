class PascalTypes < PascalBase
  def classes
    @classes ||= klass(name, declaration, first: true)
      .flatten
      .compact
      .each_with_object({}) do |item, hash|
        hash.merge!(item)
      end
  end

  def array?(hash)
    hash[:array] && hash[:array].is_a?(Hash)
  end

  def array_of_primitives?(hash)
    hash[:array] && hash[:array].is_a?(String)
  end

  def klass?(hash)
    hash.is_a?(Hash)
  end

  def t_collection(name)
    if(opts[:original_name])
      opts[:original_name] = false
      super.tap { opts[:original_name] = true }
    else
      super
    end
  end

  def t_name(name)
    if(opts[:original_name])
      name
    else
      super
    end
  end

  def klass(name, hash, opts = {})
    return nil unless hash.is_a?(Hash)
    if opts[:first] && hash[:array]
      [ { t_collection(name) => hash }, klass(name, hash[:array]) ]
    elsif !opts[:first] && hash[:array]
      [ { t_name(name) => hash[:array] }, klass(name, hash[:array]) ]
    else
      [
        { t_name(name) => hash },
        hash.flat_map do |key, value|
          if klass?(value) && array?(value)
            [ { t_name(key) => value[:array] }, klass(name, value[:array]) ]
          elsif klass?(value) && !array?(value) && !array_of_primitives?(value)
            [ { t_name(key) => value }, klass(key, value) ]
          elsif klass?(value) && array_of_primitives?(value)
            nil
          else
            klass(key, value)
          end
        end
      ]
    end
  end
end
