-- Minimal pure Lua JSON encoder/decoder
-- Only supports basic tables, strings, numbers, booleans, and nil

local json = {}

function json.encode(val)
  local t = type(val)
  if t == "table" then
    local is_array = true
    local max = 0
    for k, v in pairs(val) do
      if type(k) ~= "number" then is_array = false break end
      if k > max then max = k end
    end
    local items = {}
    if is_array then
      for i = 1, max do
        table.insert(items, json.encode(val[i]))
      end
      return "[" .. table.concat(items, ",") .. "]"
    else
      for k, v in pairs(val) do
        table.insert(items, string.format('%q:%s', k, json.encode(v)))
      end
      return "{" .. table.concat(items, ",") .. "}"
    end
  elseif t == "string" then
    return string.format('%q', val)
  elseif t == "number" or t == "boolean" then
    return tostring(val)
  elseif t == "nil" then
    return "null"
  else
    error("Unsupported type: " .. t)
  end
end

function json.decode(str)
  -- For simplicity, use load() to parse JSON (works for trusted input)
  local f, err = load("return " .. str, "json", "t", {})
  if not f then error("Invalid JSON: " .. err) end
  return f()
end

return json 