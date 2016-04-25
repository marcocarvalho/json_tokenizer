module Normalizator
  def unwanted_attributes(field, type)
    !type || type == 'NilClass' || ( type.is_a?(Hash) && type.include?(:array) && !type[:array] )
  end

  def f_key(str)
    "f"+camelize(str)
  end

  def reserved_words
    @reserved_words ||= %w(type)
  end

  def p_key(str)
    extra = ''
    extra = 'p' if reserved_words.include?(str.downcase)

    extra + camelize(str)
  end

  def array_type(name)
    "TArray#{t_name(name)}"
  end

  def t_name(n)
    "T#{camelize(n)}"
  end

  def class_name
    t_name(name)
  end

  def t_collection(name)
    "TCollection#{t_name(name)}"
  end

  def collection_class?
    name =~ /^TCollection/
  end

  def extract_collection_name
    name.gsub("TCollectionT", '').downcase
  end

  def camelize(term)
    string = term.to_s
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    string.gsub!(/\//, '::')
    string
  end
end
