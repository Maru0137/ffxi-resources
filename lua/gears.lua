local function rows()
  local resources = "../thirdparty/resources/resources_data/"

  local items = require(resources.."items")
  local item_descs = require(resources.."item_descriptions")
  
  local gears = {}

  for k, v in pairs(items) do
    if v.category == 'Weapon' or v.category == 'Armor' then
      new_v = {
        id = v.id,
        name = v.ja,
        category = v.category,
        damage = v.damage,
        delay = v.delay,
        item_level = v.item_level,
        jobs = v.jobs,
        level = v.level,
        skill = v.skill,
        slots = v.slots,
        descs = '',
      }

      if item_descs[k] then
        new_v.descs = item_descs[k].ja
      end

      table.insert(gears, new_v)
    end
  end

  return gears
end


local function jobsBitsetToStr(bitset)
  local job_strs = {
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

  local alljob_bitset = (1 << (#job_strs + 1)) - 2
  if bitset == alljob_bitset then
    return 'All Jobs'
  end

  local str = ''
  for i, v in ipairs(job_strs) do
    if bitset & (1 << (i)) ~= 0 then
      str = str .. v
    end
  end

  return str
end


local function categoryStrToJP(en)
  local category_en_jp_map = {
    Weapon = '武器',
    Armor = '防具',
  }
  
  return category_en_jp_map[en]
end


local function skillIdToStr(id)
  local skill_strs = {
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

  return skill_strs[id]
end


local function slotsBitsetToStr(bitset)
  local slot_strs = {
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
    [14] = '右指',
    [15] = '背',
  }

  local str = ''

  for i, v in ipairs(slot_strs) do
    if bitset & (1 << (i-1)) ~= 0 then
      str = str .. v
    end
  end

  return str
end

local function categoryStr(category, skill_id, slot_bitset)
  if category == 'Weapon' then
    if slot_bitset == (1 << 3) then
      return slotsBitsetToStr(slot_bitset)
    end

    print(skillIdToStr(skill_id))
    return skillIdToStr(skill_id)
  end

  if slot_bitset == ((1 << 11) + (1 << 12)) then
    return '耳'
  elseif slot_bitset == ((1 << 13) + (1 << 14)) then
    return '指'
  end

  return slotsBitsetToStr(slot_bitset)
end


local function toReadables(gears)
  local readableGears = {}

  for _, v in pairs(gears) do 
    table.insert(readableGears,{
      id = v.id,
      name = v.name,
      category = categoryStr(v.category, v.skill, v.slots),
      damage = v.damage,
      delay = v.delay,
      item_level = v.item_level,
      jobs = jobsBitsetToStr(v.jobs),
      level = v.level,
      descs = v.descs,
    })    
  end

  return readableGears
end


return {
  rows = rows,
  toReadables = toReadables,
}
