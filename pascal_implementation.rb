require './pascal_base'

class PascalImplementation < PascalBase
  def populate_properties
    declaration.map do |field, type|
      populate_property(field, type)
    end.join("\n  ")
  end

  def populate_property(field, type)
    if type.is_a?(String)
      # TODO: deal with nulls and types we cannot understand!
      return unless respond_to?("populate_property_#{type.downcase}")
      send("populate_property_#{type.downcase}", field)
    else
      populate_composite_type(field, type)
    end
  end

  def populate_property_default(field, extra = '', dontParseField = true)
    f = dontParseField ? f_key(field) : field
    "#{f} := #{obj_get(field, extra)}"
  end

  def obj_get(field, extra)
    "obj.Get('#{field}').JsonValue.Value#{extra};"
  end

  def obj_get_string(field)
    obj_get(field, '')
  end

  def obj_get_integer(field)
    obj_get(field, '.toInteger')
  end

  def obj_get_boolean(field)
    obj_get(field, 'toBoolean')
  end

  def obj_get_double(field)
    obj_get(field, 'toDouble')
  end

  def populate_property_string(field, dontParseField = true)
    populate_property_default(field, '', dontParseField)
  end

  def populate_property_integer(field, dontParseField = true)
    populate_property_default(field, '.toInteger', dontParseField)
  end

  def populate_property_boolean(field, dontParseField = true)
    populate_property_default(field, '.toBoolean', dontParseField)
  end

  def populate_property_double(field, dontParseField = true)
    populate_property_default(field, '.toDouble', dontParseField = true)
  end

  def populate_composite_type(field, type)
    if field == :array && collection_class?
      populate_property_array(extract_collection_name, { array: type })
    elsif type.is_a?(Hash) && type[:array]
      populate_property_array(field, type)
    else
      populate_property_hash(field, type)
    end
  end

  def attr_type(field, type)
    if type[:array].is_a?(String)
      get_part = send("obj_get_#{type[:array].downcase}", field)
      "#{f_key(field)}[i] := #{get_part}"
    else
      "#{f_key(field)}[i] := #{t_name(field)}.Create(arr.Items[i]);"
    end
  end

  def class_name
    name
  end

  def populate_property_array(field, type)
    v = <<Pascal
arr := TJSONArray(obj.Get('#{field}').JsonValue);
  SetLength(#{f_key(field)}, arr.Count);
  for i := 0 to (arr.Count - 1) do
  begin
    #{attr_type(field, type)}
  end;
Pascal
  end

  def populate_property_hash(field, type)
    "#{f_key(field)} := #{t_name(field)}.Create(obj.Get('#{field}').JsonValue);"
  end

  def template
    v = <<Pascal
constructor #{class_name}.create(value: TJSONValue);
begin
  populate(value);
end;

constructor #{class_name}.create(value: String);
var
  v: TJSONValue;
begin
  v := TJSONObject.ParseJSONValue(value);
  populate(v);
end;

procedure #{class_name}.populate(value: TJSONValue);
var
  obj: TJSONObject;
  arr: TJSONArray;
  count: Integer;
  i: Integer;
begin
  obj := TJSONObject(value);
  #{populate_properties}
end;
Pascal
  end

  alias_method :to_s, :template
end

__END__

  fChannel    := obj.Get('channel').JsonValue.Value;
  fSuccessful := obj.Get('successful').JsonValue.Value.ToBoolean;
  fVersion    := obj.Get('version').JsonValue.Value;
  arr         := TJSONArray(obj.Get('supportedConnectionTypes').JsonValue);
  SetLength(fSupportedconnectiontypes, arr.Count);
  for i := 0 to (arr.Count - 1) do
  begin
    fSupportedconnectiontypes[i] := TJSONString(arr.Items[i]).Value;
  end;
  fClientid  := obj.Get('clientId').JsonValue.Value;

  arr        := TJSONArray(obj.Get('advice').JsonValue);
  SetLength(fAdvice, arr.Count);
  for i := 0 to (arr.Count - 1) do
  begin
    fAdvice[i] := TAdvice.create(arr.Items[i]);
  end;
  //fAdvice: TArrayTAdvice;

