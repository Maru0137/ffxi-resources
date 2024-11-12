package.path=package.path..';./lua/?.lua'

local util = require("util")

local function instance(class, super, ...)
  local self = (super and super.new(...) or {})
  setmetatable(self, {__index = class})
  setmetatable(class, {__index = super})
  return self
end


local Enum = {}
Enum.new = function(id)
  local self = instance(Enum)
  self.id = id

  return self
end;

Enum.toString = function(self)
  return strs[self.id]
end;


local JobBitSet = {}
JobBitSet.new = function(bitset)
  local self = instance(JobBitSet)
  self.bitset = bitset

  return self
end;

JobBitSet.toString = function(self)
  local strs = {
    [1] = '戦',
    [2] = 'モ',
    [3] = '白',
    [4] = '黒',
    [5] = '赤',
    [6] = 'シ',
    [7] = 'ナ',
    [8] = '暗',
    [9] = '獣',
    [10] = '詩',
    [11] = '狩',
    [12] = '侍',
    [13] = '忍',
    [14] = '竜',
    [15] = '召',
    [16] = '青',
    [17] = 'コ',
    [18] = 'か',
    [19] = '踊',
    [20] = '学',
    [21] = '風',
    [22] = '剣',
  }  
  
  local alljob_bitset = (1 << (#strs + 1)) - 2
  if self.bitset == alljob_bitset then
    return 'All Jobs'
  end
  
  local str = ''
  for i, v in ipairs(strs) do
    if self.bitset & (1 << (i)) ~= 0 then
      str = str .. v
    end
  end
  
  return str
end;


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


local SlotBitSet = {}

SlotBitSet.new = function(bitset)
  local self = instance(SlotBitSet)
  self.bitset = bitset

  return self
end; 

SlotBitSet.toString = function(self)
  local strs = {
    [1] = 'メインウェポン',
    [2] = 'サブウェポン',
    [3] = 'レンジウェポン',
    [4] = '矢弾',
    [5] = '頭',
    [6] = '胴',
    [7] = '両手',
    [8] = '両脚',
    [9] = '両足',
    [10] = '首',
    [11] = '腰',
    [12] = '左耳',
    [13] = '右耳',
    [14] = '左指',
    [15] = '右指',
    [16] = '背',
  }

  local str = ''
  for i, v in ipairs(strs) do
    if self.bitset & (1 << (i-1)) ~= 0 then
      str = str .. v
    end
  end

  return str
end


local Category = {
  new = function(id)
    local self = Enum.new(id)
    return self
  end; 

  toString = function(self)
    local strs = {
      Weapon = '武器',
      Armor = '防具',
    }

    return strs[self.id]
  end;
}

Gear = {}

Gear.new = function(id, name, category, damage, delay, item_level, jobs, level, skill, slots, desc)
  local self = instance(Gear)
  self.id = id
  self.name = name
  self.category = category
  self.damage = damage
  self.delay = delay
  self.item_level = item_level
  self.jobs = jobs
  self.level = level
  self.skill = skill
  self.slots = slots
  self.desc = desc
 
  return self
end;
 
Gear.convertFromWindower = function(item, desc)
  local jobs = JobBitSet.new(item.jobs)
  local skill = Skill.new(item.skill)
  local slots = SlotBitSet.new(item.slots)

  local ret = Gear.new(item.id, item.ja, item.category, item.damage, item.delay, item.item_level, jobs, item.level, skill, slots, '')

  if desc then
    ret.desc = desc.ja
  end

  return ret
end;

Gear.categoryStrToJP = function(en)
  local category_en_jp_map = {
    Weapon = '武器',
    Armor = '防具',
  }
    
  return category_en_jp_map[en]
end;

Gear.categoryStr = function(self)
  if self.category == 'Weapon' then
    if self.slots.bitset == (1 << 1) then
      return 'グリップ'
  elseif self.slots.bitset == (1 << 3) then
      return self.slots:toString()
    end
  
    return self.skill:toString()
  end
 
  if self.slots.bitset == (1 << 1) then
    return '盾'
  elseif self.slots.bitset == ((1 << 11) + (1 << 12)) then
    return '耳'
  elseif self.slots.bitset == ((1 << 13) + (1 << 14)) then
    return '指'
  end
  
  return self.slots:toString()
end;
   
Gear.toReadables = function(self)
  return {
    id = self.id,
    name = self.name,
    category = self:categoryStr(),
    damage = self.damage,
    delay = self.delay,
    item_level = self.item_level,
    jobs = self.jobs:toString(),
    level = self.level,
    desc = self.desc,
  }
end;


local Gears = {}
Gears.new = function()
  local self = instance(Gears)
  self.gears = {}
  return self
end;

Gears.convertFromWindower = function(items, descs)
  local ret = Gears.new()

  for k, v in pairs(items) do
    if v.category == 'Weapon' or v.category == 'Armor' then
      table.insert(ret.gears, Gear.convertFromWindower(v, descs[k]))
    end
  end

  return ret
end;

Gears.toReadables = function(self)
  local readableGears = {}
  
  for _, v in pairs(self.gears) do 
    table.insert(readableGears, v:toReadables())
  end
  
  return readableGears
end;



local function rows(items, descs)
  return Gears.convertFromWindower(items, descs)
end

return {
  Gears = Gears,
  rows = rows,
}
