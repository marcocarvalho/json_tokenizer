module Normalizator
  def f_key(str)
    "f"+str.to_s.capitalize
  end

  def array_type(name)
    "TArray#{t_name(name)}"
  end

  def t_name(n)
    "T#{n.capitalize}"
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
end
