require './pascal_base'

class PascalImplementation < PascalBase
  def populate_properties
    declaration.map do |field, type|
      populate_property(field, type)
    end.join("\n  ")
  end

  def populate_property(field, type)
    if type.is_a?(String)
      send("populate_property_#{type.downcase}", field)
    else
      populate_composite_type(field, type)
    end
  end

  def populate_property_default(field, extra = '')
    "#{f_key(field)} := obj.Get('#{field}').JsonValue.Value#{extra};"
  end

  def populate_property_string(field)
    populate_property_default(field)
  end

  def populate_property_integer(field)
    populate_property_default(field, '.toInteger')
  end

  def populate_property_boolean(field)
    populate_property_default(field, '.toBoolean')
  end

  def populate_property_double(field)
    populate_property_default(field, '.toDouble')
  end

  def populate_composite_type(field, type)
    klass = type.class.to_s.downcase
    # populate_property_array or populate_property_hash
    send("populate_property_#{klass}", field, type)
  end

  def populate_property_array(field, type)
    v = <<Pascal
  arr := TJSONArray(obj.Get('#{field}').JsonValue);
  SetLength(#{f_key(field)}, arr.Count);
  for i := 0 to (arr.Count - 1) do
  begin
    #{f_key(field)}[i] := #{t_key(field)}.create(arr.Items[i]);
  end;
Pascal
  end

  def populate_property_hash(field, type)
    "#{f_key(field)} := #{t_key(field)}.Create(obj.Get('#{field}').JsonValue);"
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

