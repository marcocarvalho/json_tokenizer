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
    hash.flat_map do |key, value|
      if key == :array
        [ opts[:first] ? { t_collection(name) => { array: value }, t_name(name) => value } : nil, klass(name, value) ]
      elsif klass?(value) && array?(value)
        [ { t_name(key) => value[:array] }, klass(name, value[:array]) ]
      else
        nil
      end
    end
  end
end
