package.path=package.path..';./lua/?.lua'

require("instance")
require("job")

JobBitSet = {}

JobBitSet.new = function(bitset)
  local self = instance(JobBitSet)
  self.bitset = bitset

  return self
end;

JobBitSet.toString = function(self)
  local alljob_bitset = (1 << (Job.size() + 1)) - 2
  if self.bitset == alljob_bitset then
    return 'All Jobs'
  end

  local str = ''
  for k, v in pairs(Jobs) do
    if self.bitset & (1 << (v)) ~= 0 then
      str = str .. Job.new(k):toInitial()
    end
  end
  
  return str 
end; 

return {
  JobBitSet = JobBitSet,
  new = new,
}
