package.path=package.path..';./lua/?.lua'

require("instance")

Skill = {}

Skill.new = function(id)
  local self = instance(Skill)
  self.id = id
  return self
end; 

Skill.toString = function(self)
  local strs = {
    [1] = '格闘',
    [2] = '短剣',
    [3] = '片手剣',
    [4] = '両手剣',
    [5] = '片手斧',
    [6] = '両手斧',
    [7] = '両手鎌',
    [8] = '両手槍',
    [9] = '片手刀',
    [10] = '両手刀',
    [11] = '片手棍',
    [12] = '両手棍',
    [25] = '弓術',
    [26] = '射撃',
    [27] = '投てき'
  }

  return strs[self.id]
end;

return {
  Skill = Skill,
}
