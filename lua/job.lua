Jobs = {
  WAR = 1,
  MNK = 2,
  WHM = 3,
  BLM = 4,
  RDM = 5,
  THF = 6,
  PLD = 7,
  DRK = 8,
  BST = 9,
  BRD = 10,
  RNG = 11,
  SAM = 12,
  NIN = 13,
  DRG = 14,
  SMN = 15,
  BLU = 16,
  COR = 17,
  PUP = 18,
  DNC = 19,
  SCH = 20,
  GEO = 21,
  RUN = 22,
}

Job = {}

Job.new = function(key)
  local self = instance(Job)
  self.key = key
  return self
end;

Job.get_id = function(self)
  return Jobs[self.key]
end;

Job.toString = function(self)
  local strs = {
    [1] = '戦士',
    [2] = 'モンク',
    [3] = '白魔道士',
    [4] = '黒魔道士',
    [5] = '赤魔道士',
    [6] = 'シーフ',
    [7] = 'ナイト',
    [8] = '暗黒騎士',
    [9] = '獣使い',
    [10] = '吟遊詩人',
    [11] = '狩人',
    [12] = '侍',
    [13] = '忍者',
    [14] = '竜騎士',
    [15] = '召喚士',
    [16] = '青魔道士',
    [17] = 'コルセア',
    [18] = 'からくり士',
    [19] = '踊り子',
    [20] = '学者',
    [21] = '風水士',
    [22] = '魔導剣士',
  }  

  return strs[self:get_id()]
end;

Job.toInitial = function(self)
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
    [10] = '吟',
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

  return strs[self:get_id()]
end;

Job.size = function()
  return #Jobs
end;

return {
  Jobs = Jobs,
  Job = Job,
}
