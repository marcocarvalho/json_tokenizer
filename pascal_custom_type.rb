require './pascal_base'

class PascalCustomType < PascalBase

  def arrays
    array(name, declaration)
  end

  def array(name, hash)
    return nil unless hash.is_a?(Hash)
    hash.flat_map do |key, value|
      if key == :array
        "  #{array_type(name)} = array of #{t_name(name)}"
      else
        array(key, value)
      end
    end
  end

  def template
    declaration.select { |_, value| value.is_a?(Hash) }.map do |key, value|
      if(value.values.first.is_a?(String))
        "  #{array_type(key)} = array of #{value.values.first};"
      else
        "  #{array_type(key)} = array of #{t_name(key)};"
      end
    end
  end
end
