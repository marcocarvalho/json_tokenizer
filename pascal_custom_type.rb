require './pascal_base'

class PascalCustomType < PascalBase
  def arrays
    @arrays ||=
      array(name, declaration)
        .flatten
        .compact
        .each_with_object({}) do |item, hash|
          hash.merge!(item)
        end
  end

  def array(name, hash)
    return nil unless hash.is_a?(Hash)
    hash.flat_map do |key, value|
      if key == :array && value.is_a?(Hash)
        [ { array_type(name) => t_name(name) }, array( name, value) ]
      elsif key == :array && !value.is_a?(Hash)
        [ array_type(name) => value ]
      else
        array(key, value)
      end
    end
  end

  def template
    arrays.map do |key, value|
      "  #{key} = array of #{value};"
    end
  end
end
