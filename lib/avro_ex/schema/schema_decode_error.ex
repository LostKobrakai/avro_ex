defmodule AvroEx.Schema.DecodeError do
  defexception [:message]

  def new({:unrecognized_fields, keys, type, data}) do
    qualifier =
      case keys do
        [_] -> "key"
        _ -> "keys"
      end

    message =
      "Unrecognized schema #{qualifier} #{Enum.map_join(keys, ", ", &surround(&1))} for #{inspect(type)} in #{inspect(data)}"

    %__MODULE__{message: message}
  end

  def new({:missing_required, key, type, data}) do
    message = "Schema missing required key #{surround(key)} for #{inspect(type)} in #{inspect(data)}"
    %__MODULE__{message: message}
  end

  def new({:nested_union, nested, union}) do
    nested = AvroEx.Schema.type_name(nested)
    message = "Union contains nested union #{nested} as immediate child in #{inspect(union)}"
    %__MODULE__{message: message}
  end

  def new({:duplicate_union_type, schema, union}) do
    type = AvroEx.Schema.type_name(schema)
    message = "Union contains duplicated #{type} in #{inspect(union)}"
    %__MODULE__{message: message}
  end

  def new({:duplicate_symbol, symbol, enum}) do
    message = "Enum contains duplicated symbol #{surround(symbol)} in #{inspect(enum)}"
    %__MODULE__{message: message}
  end

  def new({:invalid_name, {field, name}, context}) do
    message = "Invalid name #{surround(name)} for #{surround(field)} in #{inspect(context)}"
    %__MODULE__{message: message}
  end

  def new({:invalid_default, schema, reason}) do
    type = AvroEx.Schema.type_name(schema)
    message = "Invalid default in #{type} #{Exception.message(reason)}"
    %__MODULE__{message: message}
  end

  def new({:invalid_format, data}) do
    message = "Invalid schema format #{inspect(data)}"
    %__MODULE__{message: message}
  end

  defp surround(string, value \\ "`") do
    value <> to_string(string) <> value
  end
end
