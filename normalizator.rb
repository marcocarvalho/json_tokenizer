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
end
