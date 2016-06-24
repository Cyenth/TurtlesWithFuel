-----------------------------------------------------------------------------
-- twf_ores.lua
-- 
-- This file contains several convienent actions regarding ores that are 
-- helpful when mining. Ore's are detected using a blacklist rather than a 
-- whitelist since it's more convienent for mods
-- 
-- @author Timothy 
-- @namespace twf.ores
-----------------------------------------------------------------------------

dofile('twf_actionpath.lua')

if not twf.ores then twf.ores = {} end
if not twf.ores.action then twf.ores.action = {} end

-----------------------------------------------------------------------------
-- twf.ores.DEFAULT_BLACKLIST
--
-- Default blacklist for detect ore functions
-----------------------------------------------------------------------------
if not twf.ores.DEFAULT_BLACKLIST then 
  twf.ores.DEFAULT_BLACKLIST = {
    'minecraft:flowing_water',
    'minecraft:water',
    'minecraft:flowing_lava',
    'minecraft:lava',
    'minecraft:cobblestone',
    'minecraft:stone',
    'minecraft:dirt',
    'minecraft:sand',
    'minecraft:sandstone',
    'minecraft:gravel',
    'minecraft:netherrack',
    'minecraft:soul_sand',
    'minecraft:grass',
    'minecraft:tallgrass',
    'minecraft:bedrock',
    'chisel:andesite',
    'chisel:limestone',
    'chisel:granite',
    'chisel:diorite',
    'chisel:marble',
    'BiomesOPlenty:mud',
    'appliedenergistics2:tile.BlockSkyStone'
  }
end

-----------------------------------------------------------------------------
-- twf.ores.OreBlacklist
-- 
-- A simple class that can check if an ore is inside a ore blacklist
----------------------------------------------------------------------------- 
if not twf.ores.OreBlacklist then
  local OreBlacklist = {}
  
  
  -----------------------------------------------------------------------------
  -- The blacklist of names that are not considered to be ores.
  --
  -- Ex:
  -- { 'minecraft:cobblestone', 'minecraft:dirt' }
  -----------------------------------------------------------------------------
  OreBlacklist.blacklist = nil
  
  function OreBlacklist:new(o) 
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if not o.blacklist then 
      error('Expected table of block names, but got ' .. type(o.blacklist))
    end
    
    local clone = {}
    for key, val in ipairs(o.blacklist) do 
      clone[key] = val
    end
    
    o.blacklist = clone
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Checks if this ore blacklist contains the specified block name 
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
  --   if blacklist:contains('minecraft:dirt') then 
  --     print('dirt banned!')
  --   end
  --
  -- @param blockName the block name to check
  -- @return if the blacklist contains the specified block name
  -----------------------------------------------------------------------------
  function OreBlacklist:contains(blockName)
    for i = 1, #self.blacklist do 
      if self.blacklist[i] == blockName then 
        return true
      end
    end
    
    return false
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this ore blacklist into an object
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
  --   local serialized = blacklist:serializableObject()
  --   local unserialized = twf.ores.OreBlacklist.unserializeObject(serialized)
  --
  -- @return object that can be serialized with textutils
  -----------------------------------------------------------------------------
  function OreBlacklist:serializableObject()
    local resultTable = {}
    
    resultTable.blacklist = self.blacklist
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the ore blacklist that was serialized with serializableObject
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
  --   local serialized = blacklist:serializableObject()
  --   local unserialized = twf.ores.OreBlacklist.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @return object that was serialized
  -----------------------------------------------------------------------------
  function OreBlacklist.unserializeObject(serTable)
    local blacklist = serTable.blacklist
    
    return OreBlacklist:new({blacklist = blacklist})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this ore blacklist into a string
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
  --   local serialized = blacklist:serialize()
  --   local unserialized = twf.ores.OreBlacklist.unserialize(serialized)
  --
  -- @return serialized string
  -----------------------------------------------------------------------------
  function OreBlacklist:serialize()
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes the ore blacklist that was serialized with serialize
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
  --   local serialized = blacklist:serialize()
  --   local unserialized = twf.ores.OreBlacklist.unserialize(serialized)
  --
  -- @param serTable the serialized object
  -- @return object that was serialized
  -----------------------------------------------------------------------------
  function OreBlacklist.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    return OreBlacklist.unserializeObject(serTable)
  end
  
  twf.ores.OreBlacklist = OreBlacklist
end

-----------------------------------------------------------------------------
-- twf.ores.action.DetectOreAction
-- 
-- Attempts to see if the block in the specified direction is an ore of some 
-- form.
----------------------------------------------------------------------------- 
if not twf.ores.action.DetectOreAction then 
  local DetectOreAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DetectOreAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The direction to inspect in 
  -----------------------------------------------------------------------------
  DetectOreAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- twf.ores.OreBlacklist the ore blacklist
  -----------------------------------------------------------------------------
  DetectOreAction.blacklist = nil
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action. If blacklist is nil, a reasonable 
  -- default is set.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DetectOreAction:new({direction = twf.movement.direction.FORWARD})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.direction is not forward, up, or down
  -----------------------------------------------------------------------------
  function DetectOreAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    local dirValid =       o.direction == twf.movement.direction.FORWARD
    dirValid = dirValid or o.direction == twf.movement.direction.UP
    dirValid = dirValid or o.direction == twf.movement.direction.DOWN
    
    if not dirValid then 
      error('Expected o.direction to be forward up or down but is ' .. o.direction)
    end
    
    if not o.blacklist then
      o.blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Inspects in the appropriate direction and returns the result. Normally for
  -- internal use.
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local act = twf.ores.action.DetectOreAction:new({direction = twf.movement.direction.FORWARD})
  --   local succ, info = act:inspect(st, actPath.pathState) -- like turtle.inspect()
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return boolean if there is an object, and { name = string, metadata = number }
  -----------------------------------------------------------------------------
  function DetectOreAction:inspect(stateTurtle, pathState)
    if     self.direction == twf.movement.direction.FORWARD then return turtle.inspect()
    elseif self.direction == twf.movement.direction.DOWN    then return turtle.inspectDown()
    elseif self.direction == twf.movement.direction.UP      then return turtle.inspectUp()
    else error('Unexpected direction in DetectOreAction:inspect') end 
  end
  -----------------------------------------------------------------------------
  -- Performs this action. Returns the result of the action. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DetectOreAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DetectOreAction (direction = ' .. twf.movement.direction.toString(self.direction) .. ') start') 
    self.logFile.writeLine('DetectOreAction inspecting') 
    local succ, info = self:inspect(stateTurtle, pathState)
    
    if not succ then 
      self.logFile.writeLine('DetectOreAction nothing there so no ore')
      return twf.actionpath.ActionResult.FAILURE
    end
    
    local name = info.name
    
    if self.blacklist:contains(name) then 
      self.logFile.writeLine('DetectOreAction blacklist contains ' .. name .. ' - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
    
    self.logFile.writeLine('DetectOreAction blacklist doesn\'t contain ' .. name .. ' - returning success')
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DetectOreAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.ores.action.DetectOreAction
  --   print(twf.ores.action.DetectOreAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DetectOreAction.name()
    return 'twf.ores.action.DetectOreAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.ores.action.DetectOreAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DetectOreAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.direction = twf.movement.direction.serializableObject(self.direction)
    resultTable.blacklist = self.blacklist:serializableObject()
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.oers.action.DetectOreAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DetectOreAction.unserializeObject(serialized, actionPath)
    local direction = twf.movement.direction.unserializeObject(serialized.direction)
    local blacklist = twf.ores.OreBlacklist.unserializeObject(serialized.blacklist)
    
    return DetectOreAction:new({direction = direction, blacklist = blacklist})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.ores.action.DetectOreAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DetectOreAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject(), actionPath)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.ores.action.DetectOreAction.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DetectOreAction.unserialize(serialized, actionPath)
    return DetectOreAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.ores.action.DetectOreAction = DetectOreAction
end

if not twf.ores._digveinaction then twf.ores._digveinaction = {} end

-----------------------------------------------------------------------------
-- twf.ores._digveinaction (dig vein action)
--
-- A collection of actions that are pushed to twf.ores.action.DigVeinAction's
-- internal stack. Not normally used directly, but must be registered for 
-- twf.ores.action.DigVeinAction to work correctly.
-----------------------------------------------------------------------------
do
  local _digveinaction = twf.ores._digveinaction
  
  -----------------------------------------------------------------------------
  -- twf.ores._digveinaction.Action 
  -- 
  -- A description of how actions in this package are used.
  -----------------------------------------------------------------------------
  if not _digveinaction.Action then  
    local Action = {}

    -----------------------------------------------------------------------------
    -- The log file handle for this action. May be nil
    -----------------------------------------------------------------------------
    Action.logFile = nil
    
    -----------------------------------------------------------------------------
    -- Initializes a new instance of this action.
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local act = twf.ores._digveinaction.Action:new()
    --
    -- @param o (optional) superseding object
    -- @return a new instance of this action
    -----------------------------------------------------------------------------
    function Action:new(o)
      error('twf.ores._digveinaction.Action:new(o) should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- Performs this action.
    --
    -- Usage: Requires modifying twf.ores.action.DigVeinAction
    --
    -- @param stateTurtle   the stateful turtle
    -- @param pathState     the current state of the path
    -- @param digVeinAction the dig vein action to get the blacklist and move 
    --                      stack from.
    -----------------------------------------------------------------------------
    function Action:perform(stateTurtle, pathState, digVeinAction)
      error('twf.ores._digveinaction.Action:perform(stateTurtle, pathState, digVeinAction) should not be called!')
    end
    
    -----------------------------------------------------------------------------
    -- A unique name for this action
    --
    -- @return a unique name for this action
    -----------------------------------------------------------------------------
    function Action.name()
      return 'twf.ores._digveinaction.Action'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action into an object
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local actPath = twf.actionpath.ActionPath:new()
    --   actPath:registerActions(twf.movement.action, 
    --                           twf.inventory.action,
    --                           twf.actionpath.action,
    --                           twf.ore.action,
    --                           twf.ore._digveinaction)
    --   local act = twf.ores._digveinaction.Action:new()
    --   local serialized = act:serializableObject(actPath)
    --   local unserialized = twf.ores._digveinaction.Action.unserializeObject(serialized)
    --
    -- @param actionPath the action path (for serializing children)
    -- @return an object that can be serialized with textutils
    -----------------------------------------------------------------------------
    function Action:serializableObject(actionPath)
      error('twf.ores._digveinaction.Action:serializableObject(actionPath) should not be called!')
    end
    
    
    -----------------------------------------------------------------------------
    -- Unserializes an action that was serialized using serializableObject
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local actPath = twf.actionpath.ActionPath:new()
    --   actPath:registerActions(twf.movement.action, 
    --                           twf.inventory.action,
    --                           twf.actionpath.action,
    --                           twf.ore.action,
    --                           twf.ore._digveinaction)
    --   local act = twf.ores._digveinaction.Action:new()
    --   local serialized = act:serializableObject(actPath)
    --   local unserialized = twf.ores._digveinaction.Action.unserializeObject(serialized)
    --
    -- @param serialized the serialized object
    -- @param actionPath the action path (for serializing children)
    -- @return the object that was serialized
    -----------------------------------------------------------------------------
    function Action.unserializeObject(serialized, actionPath)
      error('twf.ores._digveinaction.Action:unserializeObject(serialized, actionPath) should not be called!')
    end
    
    _digveinaction.Action = Action
  end
  
  -----------------------------------------------------------------------------
  -- twf.ores._digveinaction.DigVeinActionImpl 
  -- 
  -- This action will inspect a block in a specific direction, and if it 
  -- decides it is an ore, it will push:
  --   1: DigAction - dig that ore block 
  --   2: MoveAction - move to where that ore block was
  --   3: DigVeinActionImpl - dig vein action impl forward (originally in front of ore)
  --   4: DigVeinActionImpl - dig vein action impl up      (originally above ore)
  --   5: DigVeinActionImpl - dig vein action impl down    (originally below ore)
  --   6: TurnAction - turn left 
  --   7: DigVeinActionImpl - dig vein action impl forward (originally left of ore)
  --   8: TurnAction - turn left 
  --   9: DigVeinActionImpl - dig vein action impl forward (originally back of ore)
  --   10: TurnAction - turn left
  --   11: DigVeinActionImpl - dig vein action impl forward (originally right of ore)
  --   12: TurnAction - turn left
  --   13: MoveAction - move to where we started
  -- 
  -- Otherwise, this action does nothing
  -----------------------------------------------------------------------------
  if not _digveinaction.DigVeinActionImpl then  
    local DigVeinActionImpl = {}
    
    -----------------------------------------------------------------------------
    -- The log file handle for this action. May be nil
    -----------------------------------------------------------------------------
    DigVeinActionImpl.logFile = nil
    
    -----------------------------------------------------------------------------
    -- The direction to search for ores in
    -----------------------------------------------------------------------------
    DigVeinActionImpl.direction = nil
    
    -----------------------------------------------------------------------------
    -- Initializes a new instance of this action.
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local act = twf.ores._digveinaction.DigVeinActionImpl:new()
    --
    -- @param o superseding object
    -- @return a new instance of this action
    -----------------------------------------------------------------------------
    function DigVeinActionImpl:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      
      local dirValid =       o.direction == twf.movement.direction.FORWARD
      dirValid = dirValid or o.direction == twf.movement.direction.UP 
      dirValid = dirValid or o.direction == twf.movement.direction.DOWN
      
      if not dirValid then 
        error('Expected o.direction to be forward, up, or down but is ' .. o.direction)
      end
      
      return o
    end
    
    -----------------------------------------------------------------------------
    -- Sets the log file for this action and its children, if any
    --
    -- @param logFile the log file
    -----------------------------------------------------------------------------
    function DigVeinActionImpl:setLogFile(logFile)
      self.logFile = logFile
    end
  
    -----------------------------------------------------------------------------
    -- Performs this action.
    --
    -- Usage: Requires modifying twf.ores.action.DigVeinAction
    --
    -- @param stateTurtle   the stateful turtle
    -- @param pathState     the current state of the path
    -- @param digVeinAction the dig vein action to get the blacklist and move 
    --                      stack from.
    -----------------------------------------------------------------------------
    function DigVeinActionImpl:perform(stateTurtle, pathState, digVeinAction)
      self.logFile.write('DigVeinActionImpl (direction = ' .. twf.movement.direction.toString(self.direction) .. ') start')
      self.logFile.write('DigVeinActionImpl determining if there is an ore')
      local isOre = digVeinAction:isOre(stateTurtle, pathState, self.direction)
      
      if not isOre then 
        self.logFile.write('DigVeinActionImpl there is not - returning success')
        return twf.actionpath.ActionResult.SUCCESS
      end
      
      self.logFile.write('DigVeinActionImpl there is - pushing child actions to the stack')
      
      -- pull a few constants out to make these lines easier to read
      local left = twf.movement.direction.LEFT
      local forward = twf.movement.direction.FORWARD
      local back = twf.movement.direction.BACK
      local down = twf.movement.direction.DOWN
      local up = twf.movement.direction.UP
      
      local MoveAction = twf.movement.action.MoveAction
      local TurnAction = twf.movement.action.TurnAction
      local DigAction = twf.inventory.action.DigAction
      
      local MRI = twf.actionpath.action.MoveResultInterpreterAction
      local DRI = twf.actionpath.action.DigResultInterpreterAction
      
      local digThenMove = function(dir) 
        local res = twf.actionpath.action.SequenceAction:new({children = {
          twf.actionpath.action.SucceederAction:new({child = 
            twf.actionpath.action.RepeatUntilFailureAction:new({child =
              DRI:new({child = DigAction:new({direction = dir}), noBlockIsSuccess = false})
            })
          }),
          MRI:new({child = MoveAction:new({direction = dir})})
        }})
        return res
      end
      
      --[[ 13 ]] table.insert(digVeinAction.moveStack, MRI:new({child = MoveAction:new({direction = twf.movement.direction.inverse(self.direction)})}))
      --[[ 12 ]] table.insert(digVeinAction.moveStack, MRI:new({child = TurnAction:new({direction = left})}))
      --[[ 11 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = forward}))
      --[[ 10 ]] table.insert(digVeinAction.moveStack, MRI:new({child = TurnAction:new({direction = left})}))
      --[[  9 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = forward}))
      --[[  8 ]] table.insert(digVeinAction.moveStack, MRI:new({child = TurnAction:new({direction = left})}))
      --[[  7 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = forward}))
      --[[  6 ]] table.insert(digVeinAction.moveStack, MRI:new({child = TurnAction:new({direction = left})}))
      --[[  5 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = down}))
      --[[  4 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = up}))
      --[[  3 ]] table.insert(digVeinAction.moveStack, DigVeinActionImpl:new({direction = forward}))
      --[[2|1 ]] table.insert(digVeinAction.moveStack, digThenMove(self.direction))
      
      digVeinAction:setLogFile(digVeinAction.logFile) -- set child log files
      
      self.logFile.write('DigVeinActionImpl returning success')
      return twf.actionpath.ActionResult.SUCCESS
    end
    
    -----------------------------------------------------------------------------
    -- A unique name for this action
    --
    -- @return a unique name for this action
    -----------------------------------------------------------------------------
    function DigVeinActionImpl.name()
      return 'twf.ores._digveinaction.DigVeinActionImpl'
    end
    
    -----------------------------------------------------------------------------
    -- Serializes this action into an object
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local actPath = twf.actionpath.ActionPath:new()
    --   actPath:registerActions(twf.movement.action, 
    --                           twf.inventory.action,
    --                           twf.actionpath.action,
    --                           twf.ore.action,
    --                           twf.ore._digveinaction)
    --   local act = twf.ores._digveinaction.DigVeinActionImpl:new({direction = twf.movement.direction.UP})
    --   local serialized = act:serializableObject(actPath)
    --   local unserialized = twf.ores._digveinaction.DigVeinActionImpl.unserializeObject(serialized)
    --
    -- @param actionPath the action path (for serializing children)
    -- @return an object that can be serialized with textutils
    -----------------------------------------------------------------------------
    function DigVeinActionImpl:serializableObject(actionPath)
      local resultTable = {}
      
      resultTable.direction = twf.movement.direction.serializableObject(self.direction)
      
      return resultTable
    end
    
    
    -----------------------------------------------------------------------------
    -- Unserializes an action that was serialized using serializableObject
    --
    -- Usage:
    --   dofile('twf_ores.lua')
    --   local actPath = twf.actionpath.ActionPath:new()
    --   actPath:registerActions(twf.movement.action, 
    --                           twf.inventory.action,
    --                           twf.actionpath.action,
    --                           twf.ore.action,
    --                           twf.ore._digveinaction)
    --   local act = twf.ores._digveinaction.DigVeinActionImpl:new({direction = twf.movement.direction.UP})
    --   local serialized = act:serializableObject(actPath)
    --   local unserialized = twf.ores._digveinaction.DigVeinActionImpl.unserializeObject(serialized)
    --
    -- @param serialized the serialized object
    -- @param actionPath the action path (for serializing children)
    -- @return the object that was serialized
    -----------------------------------------------------------------------------
    function DigVeinActionImpl.unserializeObject(serialized, actionPath)
      local direction = twf.movement.direction.unserializeObject(serialized.direction)
      
      return DigVeinActionImpl:new({direction = direction})
    end
    
    _digveinaction.DigVeinActionImpl = DigVeinActionImpl
  end
  
  
  -- Add serialize / unserialize functions 
  
  for _, act in pairs(twf.ores._digveinaction) do 
    function act:serialize(actionPath) 
      return textutils.serialize(self:serializableObject(actionPath))
    end
    
    function act.unserialize(serialized, actionPath)
      return act.unserializeObject(textutils.unserialize(serialized), actionPath)
    end
  end
  
  twf.ores._digveinaction = _digveinaction
end
-----------------------------------------------------------------------------
-- twf.ores.action.DigVeinAction
-- 
-- Detects and digs out a vein of ores. Returns success if the turtle ends at 
-- the same place and direction it started in, returns failure otherwise.
----------------------------------------------------------------------------- 
if not twf.ores.action.DigVeinAction then 
  local DigVeinAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DigVeinAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The direction to inspect in originally
  -----------------------------------------------------------------------------
  DigVeinAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- twf.ores.OreBlacklist the ore blacklist
  -----------------------------------------------------------------------------
  DigVeinAction.blacklist = nil
  
  -----------------------------------------------------------------------------
  -- An array of Actions to be performed. These are not quite standard actions,
  -- see twf.ores.__digveinactions.Action for a description
  -----------------------------------------------------------------------------
  DigVeinAction.moveStack = nil
  
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action. If blacklist is nil, a reasonable 
  -- default is set.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DigVeinAction:new({direction = twf.movement.direction.FORWARD})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.direction is not forward, up, or down
  -----------------------------------------------------------------------------
  function DigVeinAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    local dirValid =       o.direction == twf.movement.direction.FORWARD
    dirValid = dirValid or o.direction == twf.movement.direction.UP
    dirValid = dirValid or o.direction == twf.movement.direction.DOWN
    
    if not dirValid then 
      error('Expected o.direction to be forward up or down but is ' .. o.direction)
    end
    
    if not o.blacklist then
      o.blacklist = twf.ores.OreBlacklist:new({blacklist = twf.ores.DEFAULT_BLACKLIST})
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DigVeinAction:setLogFile(logFile)
    self.logFile = logFile
    if self.moveStack then 
      for _, child in ipairs(self.moveStack) do
        if type(child.setLogFile) == 'function' then 
          child:setLogFile(logFile)
        end
      end
    end
  end
  
  -----------------------------------------------------------------------------
  -- Inspects in the appropriate direction and returns the result. Normally for
  -- internal use.
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local act = twf.ores.action.DigVeinAction:new({direction = twf.movement.direction.FORWARD})
  --   local succ, info = act:inspect(st, actPath.pathState, act.direction) -- like turtle.inspect()
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @param dir the direction to inspect in
  -- @return boolean if there is an object, and { name = string, metadata = number }
  -----------------------------------------------------------------------------
  function DigVeinAction:inspect(stateTurtle, pathState, dir)
    if     dir == twf.movement.direction.FORWARD then return turtle.inspect()
    elseif dir == twf.movement.direction.DOWN    then return turtle.inspectDown()
    elseif dir == twf.movement.direction.UP      then return turtle.inspectUp()
    else error('Unexpected direction in DetectOreAction:inspect ' .. dir) end 
  end
  
  -----------------------------------------------------------------------------
  -- Checks if there is an ore in the specified direction. Normally for 
  -- internal use.
  --
  -- Usage:
  --   dofile('twf_ore.lua')
  --   local act = twf.ores.action.DigVeinAction:new({direction = twf.movement.direction.FORWARD})
  --   local oreInFront = act:isOre(st, actPath.pathState, act.direction)
  --
  -- @param stateTurtle the stateful turtle
  -- @param pathState the current state of the action path
  -- @param dir the direction to inspect in
  -----------------------------------------------------------------------------
  function DigVeinAction:isOre(stateTurtle, pathState, dir)
    local succ, info = self:inspect(stateTurtle, pathState, dir)
    
    if not succ then return false end
    
    return not self.blacklist:contains(info.name)
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. Returns the result of the action. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.ores.action.DetectOreAction:new()
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DigVeinAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DigVeinAction start')
    if self.moveStack == nil then
      self.logFile.writeLine('DigVeinAction move stack is nil; initializing movestack')
      self.moveStack = {}
      table.insert(self.moveStack, twf.ores._digveinaction.DigVeinActionImpl:new({direction = self.direction}))
      self:setLogFile(self.logFile)
      self.logFile.writeLine('DigVeinAction returning running')
      return twf.actionpath.ActionResult.RUNNING
    end
    
    if #self.moveStack == 0 then 
      self.moveStack = nil
      self.logFile.writeLine('DigVeinAction move stack is empty - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    end
    
    self.logFile.writeLine('DigVeinAction move stack is not nil or empty, popping action off')
    local act = table.remove(self.moveStack)
    self.logFile.writeLine('DigVeinAction ticking ' .. act.name())
    local result = act:perform(stateTurtle, pathState, self)
    if result == twf.actionpath.ActionResult.SUCCESS then 
      self.logFile.writeLine('DigVeinAction child returned success - returning running')
      return twf.actionpath.ActionResult.RUNNING 
    elseif result == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('DigVeinAction child returned running, putting back on movestack')
      table.insert(self.moveStack, act)
      self.logFile.writeLine('DigVeinAction returning running')
      return result
    elseif result == twf.actionpath.ActionResult.FAILURE then
      self.logFile.writeLine('DigVeinAction child returned failure, putting back on movestack - returning failure')
      table.insert(self.moveStack, act) -- this should never happen, and probably indicates we're about to die
      return result
    end
    
    error('Unexpected result! ' .. result)
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DigVeinAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.ores.action.DetectOreAction
  --   print(twf.ores.action.DetectOreAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DigVeinAction.name()
    return 'twf.ores.action.DigVeinAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DigVeinAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.ores.action.DigVeinAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DigVeinAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.direction = twf.movement.direction.serializableObject(self.direction)
    resultTable.blacklist = self.blacklist:serializableObject()
    
    if self.moveStack then 
      resultTable.moveStack = {}
      
      for i = 1, #self.moveStack do 
        resultTable.moveStack[i] = actionPath:serializableObjectForAction(self.moveStack[i])
      end
    end
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DigVeinAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.oers.action.DigVeinAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DigVeinAction.unserializeObject(serialized, actionPath)
    local direction = twf.movement.direction.unserializeObject(serialized.direction)
    local blacklist = twf.ores.OreBlacklist.unserializeObject(serialized.blacklist)
    
    local moveStack = nil
    if serialized.moveStack then 
      moveStack = {}
      
      for i = 1, #serialized.moveStack do 
        moveStack[i] = actionPath:unserializeObjectOfAction(serialized.moveStack[i])
      end
    end
    
    return DigVeinAction:new({
      direction = direction, 
      blacklist = blacklist,
      moveStack = moveStack
    })
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DigVeinAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.ores.action.DigVeinAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DigVeinAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject(), actionPath)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.ores.action.DigVeinAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.ores.action.DigVeinAction.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigVeinAction.unserialize(serialized, actionPath)
    return DigVeinAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.ores.action.DigVeinAction = DigVeinAction
end