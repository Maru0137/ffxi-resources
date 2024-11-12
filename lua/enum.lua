local Enum = {
  local strs = {}
  
  new = function(id)
    local self = instance(Enum)
      self.id = id
  
      return self
  end;
  
  toString = function(self)
    return strs[self.id]
  end;
}

return {
    Enum = Enum,
}
  