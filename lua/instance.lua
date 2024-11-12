local folderOfThisFile = (...):match("(.-)[^%.]+$")

require(folderOfThisFile .. "util")

function instance(class, super, ...)
  local self = (super and super.new(...) or {})
  setmetatable(self, {__index = class})
  setmetatable(class, {__index = super})
  return self
end
