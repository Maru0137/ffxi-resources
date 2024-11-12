package.path=package.path..';./lua/?.lua'

require("instance")
require("job_bitset")
require("skill")

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
