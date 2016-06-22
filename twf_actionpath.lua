-----------------------------------------------------------------------------
-- twf_actionpath.lua
--
-- This file contains all pertinent objects to programs that subscribe to the
-- action path pattern.
--
-- The action path pattern is a program that is described by a set of actions,
-- where each action is short and recoverable. This pattern increases the 
-- length of the code substantially and reduces legibility when used directly,
-- but really shines for both recovering when the turtle crashes for some 
-- reason, and dynamically creating variations on programs without 
-- significant development costs.
--
-- @author Timothy
-----------------------------------------------------------------------------

dofile('twf_movement.lua')
dofile('twf_inventory.lua')

if not twf.actionpath then twf.actionpath = {} end
if not twf.actionpath.action then twf.actionpath.action = {} end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Action 
--
-- Describes how actions will be treated in actionpaths. It should be noted
-- that this is strictly compatible with twf.movement.action.Action. 
-- 
-- @see twf.movement.action.Action
-----------------------------------------------------------------------------
if not twf.actionpath.action.Action then 
  local Action = {}
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --
  -- @param o (optional) superseding object
  -- @return  a new instance of this action
  -----------------------------------------------------------------------------
  function Action:new(o)
    error('Action:new(o) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. Returns the result of the action. The actionpath 
  -- such that the last action is assumed to have succeeded.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Action:new()
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Action:perform(stateTurtle, pathState)
    error('Action:perform(stateTurtle, pathState) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Action:updateState(stateTurtle, pathState)
    error('Action:updateState(stateTurtle, pathState should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Action
  --   print(twf.actionpath.action.Action.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Action.name()
    return 'twf.actionpath.action.Action'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function Action:serialize(actionPath)
    error('Action:serialize(actionPath) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Action.unserialize(serialized, actionPath)
    error('Action:unserialize(serialized) should not be called directly!')
  end
  
  twf.actionpath.action.Action = Action
end

-----------------------------------------------------------------------------
-- Describes an action path. An action path is a modified behavior tree, with
-- special consideration for recovery due to the high "disastrous failure" 
-- rate of turtles.
--
-- In order for successful recover, action paths should have each step 
-- involve going to absolute positions, never relative ones.
--
-- Comparing to behavior trees:
--   Action <=> Behavior 
--   Most default actions are already implemented in twf.actionpath.actions
--   Internal state can be stored and retrieved from the actionpath if 
--   desired (see extensions to twf.movement.action.Action) (primitive types
--   only)
--
-- Behavior tree useful links
-- @see https://en.wikipedia.org/wiki/Behavior_tree 
-- @see http://guineashots.com/2014/09/24/implementing-a-behavior-tree-part-1/
-- @see http://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php
--
-- This codebase
-- @see twf.actionpath.actions
-----------------------------------------------------------------------------
if not twf.actionpath.ActionPath then 
  local ActionPath = {}
  
  -----------------------------------------------------------------------------
  -- The action to start with, similiar to a linked list
  -----------------------------------------------------------------------------
  ActionPath.head = nil
  
  -----------------------------------------------------------------------------
  -- List of actions that have been registered with this action path. Required
  -- in order to load actions
  -----------------------------------------------------------------------------
  ActionPath.registeredActions = nil
  
  -----------------------------------------------------------------------------
  -- Describes the current state of this path. 
  -----------------------------------------------------------------------------
  ActionPath.pathState = nil
  
  -----------------------------------------------------------------------------
  -- Initializes a new action path
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --
  -- @param o (optional) superseding object
  -- @return a new instance of action path
  function ActionPath:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if not o.registeredActions then 
      o.registeredActions = {}
    end
    
    if not o.pathState then 
      o.pathState = {}
    end
     
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Registers the specified actions such that they may be loaded from file
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   local myCustomAction = {}
  --   function myCustomAction:new(o) error('Not yet implemented') end
  --   function myCustomAction:perform(stateTurtle, pathState) error('Not yet implemented') end
  --   function myCustomAction:updateState(stateTurtle, pathState) error('Not yet implemented') end
  --   function myCustomAction.name() return 'myCustomAction' end
  --   function myCustomAction:serialize(actionPath) error('Not yet implemented') end
  --   function myCustomAction:unserialize(serialized) error('Not yet implemented') end
  --   local myCustomAction2 = {}
  --   -- Functions, like above, omitted
  --   -- ...
  --   actPath:registerActions(myCustomAction, myCustomAction2, twf.actionpath.action)
  -- 
  -- @param arg either a table of actions or an action to load or some 
  --            combination of those
  -----------------------------------------------------------------------------
  function ActionPath:registerActions(...)
    for i = 1, #arg, 1 do 
      if type(arg[i]) == 'table' then 
        if type(arg[i].name) == 'function' then 
          self.registeredActions[#self.registeredActions + 1] = arg[i]
        else
          for key, value in pairs(arg[i]) do
            self:registerActions(value)
          end
        end
      else
        error('Unexpected thing: ' .. arg[i])
      end
    end
  end
  
  -----------------------------------------------------------------------------
  -- Loads the action path from the specified file name. Any actions referenced
  -- MUST have already been registered using registerActions
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   actPath:loadFromFile('my_prog.actionpath')
  --
  -- @param fileName the file to load from 
  -----------------------------------------------------------------------------
  function ActionPath:loadFromFile(fileName)
    local file = fs.open(fileName, 'r')
    local serialized = file.readAll()
    file.close()
    
    self:unserialize(serialized)
  end
  
  -----------------------------------------------------------------------------
  -- Saves this action path to file. Does not need to have its actions
  -- registered in order to save.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:saveToFile('my_prog.actionpath')
  -- 
  -- @param fileName the filename to save to 
  -----------------------------------------------------------------------------
  function ActionPath:saveToFile(fileName)
    local file = fs.open(fileName, 'w')
    file.write(self:serialize())
    file.close()
  end
  
  -----------------------------------------------------------------------------
  -- 'Ticks' this action path by calling the head actions perform. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   actPath:loadFromFile('my_prog.actionpath')
  --   actPath:tick()
  -----------------------------------------------------------------------------
  function ActionPath:tick(stateTurtle)
    local result = self.head:perform(stateTurtle, self)
    
    if result == twf.actionpath.ActionResult.SUCCESS then 
      self.head:updateState(stateTurtle, self)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Serializes the specified action 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializeAction(act)
  --   local unserialized = actPath:unserializeAction(act)
  --
  -- @return string serialization of the action
  -----------------------------------------------------------------------------
  function ActionPath:serializeAction(action)
    if not action then 
      error('Expected action, but got ' .. type(action))
    end
    
    if type(action.name) ~= 'function' then 
      error('Expected action, but got ' .. action .. ' (type(action.name) = ' .. type(action.name) .. ')')
    end
    
    local resultTable = {}
    
    resultTable.name = action.name()
    resultTable.action = action:serialize(self)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by unserializeAction. MUST be one of the
  -- registered actions.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializeAction(act)
  --   local unserialized = actPath:unserializeAction(act)
  --
  -- @param serializedAction the serialized action
  -- @return                 action that was serialized
  function ActionPath:unserializeAction(serializedAction)
    local serTable = textutils.unserialize(serializedAction)
    
    local name = serTable.name
    local serAction = serTable.action
    
    for i = 1, #self.registeredActions do 
      local act = self.registeredActions[i]
      if act.name() == name then 
        return act.unserialize(serAction, self)
      end
    end
  end
  -----------------------------------------------------------------------------
  -- Serializes this actionpaths head action and pathstate such that it can be 
  -- recovered by an actionpath with the same registered actions
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   local serialized = actPath:serialize()
  --   local actPath2 = twf.actionpath.ActionPath:new()
  --   actPath2:unserialize(serialized)
  --
  -- @return string serialization of this actionpath
 -----------------------------------------------------------------------------
  function ActionPath:serialize()
    local resultTable = {}
    
    resultTable.head = self:serializeAction(self.head)
    resultTable.pathState = pathState
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Loads the action path list from a string. MUST have the same 
  -- registered actions as the actionpath that was serialized for this function 
  -- to work correctly. Should be saved without overriding the "original" 
  -- actionpath file that was created to ensure successful recovery in 
  -- conjunction with twf.movement.StatefulTurtle.loadOrInit
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local serialized = actPath:serialize()
  --   local actPath2 = twf.actionpath.ActionPath:new()
  --   actPath2:registerActions(twf.actionpath.action)
  --   actPath2:unserialize(serialized)
  --
  -- @param serialized string serialization of an actionpath
  -----------------------------------------------------------------------------
  function ActionPath:unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    self.head = self:unserializeAction(serTable.head)
    self.pathState = serTable.pathState
  end
  
  twf.actionpath.ActionPath = ActionPath
end

-----------------------------------------------------------------------------
-- Action path extensions to the StatefulTurtle that allow for simple 
-- integration with action paths.
-----------------------------------------------------------------------------
if not twf.movement.StatefulTurtle.ACTIONPATH_EXTENSIONS then
  local StatefulTurtle = twf.movement.StatefulTurtle
  
  -----------------------------------------------------------------------------
  -- Executes or recovers the specified actionpath. Should not be used with 
  -- loadOrInit.
  --
  -- Remarks:
  --  First loads the actionpath from file. Due to the strict serialization 
  --  this will run the turtle in the appropriate state - the next child to
  --  be called will be correct.
  --
  -- Usage:
  --   -- Generally in startup file
  --   dofile('twf_actionpath.lua')
  --   local ActionPath = twf.actionpath.ActionPath
  --   local myProg = ActionPath:new()
  --   myProg:registerActions(twf.actionpath.action)
  --   -- register custom actions here
  --   
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:executeActionPath(myProg, 'my_program' 'state', 'actpath_state')
  --
  -- Remarks:
  --   This function will normally never return 
  --
  -- @param actionPath         the action path prepared with the necessary 
  --                           actions for loading.
  -- @param actionPathFilePref actionPathFile where the action file is saved 
  --                           normally. Postfixed with .actionpath
  -- @param statePrefix        prefix for the turtle state. 
  --                           Postfixed with .dat and _action_recovery.dat
  -- @param actPathStatePrefix prefix for the action path state.
  --                           Postfixed with _recovery.dat
  -- @see                      twf.actionpath.ActionPath
  -----------------------------------------------------------------------------
  function StatefulTurtle:executeActionPath(actionPath, actionPathFilePref, statePrefix, actPathStatePrefix)
    self.saveFile = statePrefix .. '.dat'
    self.actionRecoveryFile = actPathStatePrefix .. '_action_recovery.dat'
    
    local actionPathFile = actionPathFilePref .. '.actionpath'
    local actionPathRecoveryFile = actPathStatePrefix .. '_recovery.dat'
    
    if fs.exists(actionPathRecoveryFile) then 
      actionPath:loadFromFile(actionPathRecoveryFile)
    elseif fs.exists(actionPathFile) then 
      actionPath:loadFromFile(actionPathFile)
    else
      error('Action path not found at ' .. actionPathFile .. ' or ' .. actionPathRecoveryFile)
    end
    
    -- It's up to the actions to figure out how to handle the action recovery file
    -- Good luck to 'em!
    
    while true do 
      actionPath:tick(self)
      actionPath:saveToFile(actionPathRecoveryFile)
      self:finishAction() -- See twf.actionpath.action.MoveAction before you touch this
      
      -- Yielding here will make it slightly more likely to be 
      -- unloaded here, which is pretty much guarranteed to work
      os.queueEvent("twfFakeEventName")
      os.pullEvent("twfFakeEventName")
    end
  end
  
  StatefulTurtle.ACTIONPATH_EXTENSIONS = true
end

-- Useful things for any actionpath

-----------------------------------------------------------------------------
-- twf.actionpath.ActionResult
--
-- A result for a composite or decorator action or action-path-aware actions
-----------------------------------------------------------------------------
if not twf.actionpath.ActionResult then
  local ActionResult = {}
  
  -----------------------------------------------------------------------------
  -- Indicates the action completed successfully. Also a synonym for true for 
  -- some decorators
  -----------------------------------------------------------------------------
  ActionResult.SUCCESS = 10067
  
  -----------------------------------------------------------------------------
  -- Indicates the action needs more time to complete, and should be called 
  -- again before anything else. 
  -----------------------------------------------------------------------------
  ActionResult.RUNNING = 10069
  
  -----------------------------------------------------------------------------
  -- Indicates the action was unsuccessful. Also a synonym for false for some 
  -- decorators
  -----------------------------------------------------------------------------
  ActionResult.FAILURE = 10079
  
  -----------------------------------------------------------------------------
  -- Returns a human-readable string representation of this action result
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints action succeeded
  --   print(twf.actionpath.ActionResult.toString(twf.actionpath.ActionResult.SUCCESS))
  --
  -- @param actionResult the action result code 
  -- @return             string description of the result code
  -----------------------------------------------------------------------------
  function ActionResult.toString(actionResult)
    if     actionResult == ActionResult.SUCCESS then return 'action succeeded'
    elseif actionResult == ActionResult.RUNNING then return 'action running'
    elseif actionResult == ActionResult.FAILURE then return 'action failed'
    else error('Expected ActionResult but got ' .. actionResult) end
  end
  
  twf.actionpath.ActionResult = ActionResult
end

-- Useful actions

-- Composites

-----------------------------------------------------------------------------
-- twf.actionpath.action.SequenceAction
--
-- Visits each child in order, starting with the first. Upon success, returns
-- ActionResult.RUNNING if there is another child, otherwise returns SUCCESS.
-- If any child fails, immediately returns failure
-----------------------------------------------------------------------------
if not twf.actionpath.action.SequenceAction then
  local SequenceAction = {}
  
  -----------------------------------------------------------------------------
  -- The children of this sequence, in order
  -----------------------------------------------------------------------------
  SequenceAction.children = nil
  
  -----------------------------------------------------------------------------
  -- The current index of this sequence action
  -----------------------------------------------------------------------------
  SequenceAction.currentIndex = 1
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is not a table or is empty
  -----------------------------------------------------------------------------
  function SequenceAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.children) ~= 'table' then 
      error('Expected o.children to be a table of actions but was ' .. type(o.children) .. '!')
    elseif #o.children == 0 then 
      error('Expected o.children to be a table of actions but was empty!')
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Visits each child in order, starting with the first. If any child fails,
  -- immediately returns failure. If no child fails, returns success
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SequenceAction:perform(stateTurtle, pathState)
    local res = self.children[self.currentIndex]:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then      
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex > self.children.count then 
        self.currentIndex = 1
        return res
      end
      
      return twf.actionpath.ActionResult.RUNNING
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.currentIndex = 1
      return res
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SequenceAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SequenceAction
  --   print(twf.actionpath.action.SequenceAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SequenceAction.name()
    return 'twf.actionpath.action.SequenceAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SequenceAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      resultTable.children[i] = actionPath:serializeAction(self.children[i])
    end
    
    resultTable.currentIndex = self.currentIndex
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SequenceAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    
    return SequenceAction:new({children = children, currentIndex = currentIndex})
  end
  
  twf.actionpath.action.SequenceAction = SequenceAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SelectorAction
--
-- Visits each child in order, starting with the first. If the child returns
-- success, immediately returns success. Otherwise, returns RUNNING and when
-- called again tries the next child. If no childs are left, returns FAILURE.
-----------------------------------------------------------------------------
if not twf.actionpath.action.SelectorAction then
  local SelectorAction = {}
  
  -----------------------------------------------------------------------------
  -- A table of the children for this selector
  -----------------------------------------------------------------------------
  SelectorAction.children = nil
  
  -----------------------------------------------------------------------------
  -- The current index of this action in children
  -----------------------------------------------------------------------------
  SelectorAction.currentIndex = 1
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SelectorAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is nil or empty
  -----------------------------------------------------------------------------
  function SelectorAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.children) ~= 'table' then 
      error('Expected o.children to be a table of actions but was ' .. type(o.children) .. '!')
    elseif #o.children == 0 then 
      error('Expected o.children to be a table of actions but was empty!')
    end
    
    return o
  end
  
  
  -----------------------------------------------------------------------------
  -- Visits each child in order, starting with the first. If any child succeeds,
  -- immediately returns success. If no child succeeds, returns failure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SelectorAction:perform(stateTurtle, pathState)
    local res = self.children[self.currentIndex]:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.currentIndex = 1
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.currentIndex = self.currentIndex + 1 
      if self.currentIndex > #self.children then 
        self.currentIndex = 1
        return res
      end
      return twf.actionpath.ActionResult.SUCCESS
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SelectorAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SelectorAction
  --   print(twf.actionpath.action.SelectorAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SelectorAction.name()
    return 'twf.actionpath.action.SelectorAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SelectorAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      resultTable.children[i] = actionPath:serializeAction(self.children[i])
    end
    
    resultTable.currentIndex = self.currentIndex
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SelectorAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    
    return SelectorAction:new({children = children, currentIndex = currentIndex})
  end
  
  twf.actionpath.action.SelectorAction = SelectorAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RandomSelectorAction
--
-- Selects an action at random from a list of actions. That action is run 
-- until it returns either SUCCESS or FAILURE. If it returns success, 
-- immediately returns success. If it returns failure, another child is 
-- selected until either all children are exhausted and the selector returns
-- failure, or a child returns success.
--
-- When ticked again after returning success or failure, acts as a "blank slate" 
-- and may pick any of its children again.
-----------------------------------------------------------------------------
if not twf.actionpath.action.RandomSelectorAction then
  local RandomSelectorAction = {}
  
  -----------------------------------------------------------------------------
  -- The actions that can be chosen from
  -----------------------------------------------------------------------------
  RandomSelectorAction.children = nil
  
  -----------------------------------------------------------------------------
  -- What indexes have already been tried since the last time the selector 
  -- returned success or failure
  -----------------------------------------------------------------------------
  RandomSelectorAction.bannedIndexes = nil
  
  -----------------------------------------------------------------------------
  -- Either nil if this selector needs to pick a new action to try, or the
  -- index of the action that is currently running.
  -----------------------------------------------------------------------------
  RandomSelectorAction.currentIndex = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RandomSelectorAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.children is nil or empty
  -----------------------------------------------------------------------------
  function RandomSelectorAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.children) ~= 'table' then 
      error('Expected o.children to be a table but got ' .. type(o.children))
    end
    if #o.children < 1 then 
      error('Expected o.children to be a table with things in it, but it is empty!')
    end
    
    o.bannedIndexes = o.bannedIndexes or {}
    o.currentIndex = o.currentIndex or 1
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Visits each child randomly until one returns success or all children are
  -- exhausted, upon which time the selector returns failure.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RandomSelectorAction:perform(stateTurtle, pathState)
    local choiceIndex = -1
    if self.currentIndex == nil then 
      local remainingOptions = {}
      for i = 1, #self.children do 
        local banned = false
        for j = 1, #self.bannedIndexes do 
          if i == self.bannedIndexes[j] then 
            banned = true
            break
          end
        end
        
        if not banned then 
          remainingOptions[#remainingOptions + 1] = i
        end
      end
      
      local optionsIndex = math.random(1, #remainingOptions)
      choiceIndex = remainingOptions[choiceIndex]
      self.bannedIndexes[#self.bannedIndexes + 1] = choiceIndex
    else 
      choiceIndex = self.currentIndex
    end
    
    local choice = self.children[choiceIndex]
    local res = choice:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.bannedIndexes = {}
      self.currentIndex = nil
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.currentIndex = choiceIndex
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.currentIndex = nil
      if #self.bannedIndexes == #self.children then 
        self.bannedIndexes = {}
        return twf.actionpath.ActionResult.FAILURE
      else
        return twf.actionpath.ActionResult.RUNNING
      end
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RandomSelectorAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RandomSelectorAction
  --   print(twf.actionpath.action.RandomSelectorAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RandomSelectorAction.name()
    return 'twf.actionpath.action.RandomSelectorAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RandomSelectorAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      resultTable.children[i] = actionPath:serializeAction(self.children[i])
    end
    
    resultTable.currentIndex = self.currentIndex
    
    resultTable.bannedIndexes = self.bannedIndexes 
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new({children = {}})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RandomSelectorAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    
    local bannedIndexes = serTable.bannedIndexes
    
    return SequenceAction:new({children = children, currentIndex = currentIndex, bannedIndexes = bannedIndexes})
  end
  
  twf.actionpath.action.RandomSelectorAction = RandomSelectorAction
end

-- Decorators

-----------------------------------------------------------------------------
-- twf.actionpath.action.Inverter
--
-- Inverts the result of the child - FAILURE -> SUCCESS, RUNNING -> RUNNING, 
-- and SUCCESS -> FAILURE
-----------------------------------------------------------------------------
if not twf.actionpath.action.Inverter then
  local Inverter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this inverter
  -----------------------------------------------------------------------------
  Inverter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Inverter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Inverter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns the inverted result of the child
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Inverter:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      return twf.actionpath.ActionResult.FAILURE 
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      return twf.actionpath.ActionResult.SUCCESS
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Inverter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Inverter
  --   print(twf.actionpath.action.Inverter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Inverter.name()
    return 'twf.actionpath.action.Inverter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Inverter.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Inverter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Inverter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Inverter.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Inverter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return Inverter:new({child = child})
  end
  
  twf.actionpath.action.Inverter = Inverter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Succeeder
--
-- Except for RUNNING which is unaffected, always returns SUCCESS
-----------------------------------------------------------------------------
if not twf.actionpath.action.Succeeder then
  local Succeeder = {}
  
  -----------------------------------------------------------------------------
  -- The child of this succeeder
  -----------------------------------------------------------------------------
  Succeeder.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Succeeder
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Succeeder:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (as an Action) but it is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING, otherwise returns SUCCESS
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Succeeder:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.RUNNING then 
      return res
    end
    
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Succeeder:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Succeeder
  --   print(twf.actionpath.action.Succeeder.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Succeeder.name()
    return 'twf.actionpath.action.Succeeder'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Succeeder.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Succeeder:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Succeeder:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Succeeder.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Succeeder.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return Succeeder:new({child = child})
  end
  
  twf.actionpath.action.Succeeder = Succeeder
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RepeatUntilFailure
-- 
-- Repeats the child action until it returns failure
-----------------------------------------------------------------------------
if not twf.actionpath.action.RepeatUntilFailure then
  local RepeatUntilFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RepeatUntilFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RepeatUntilFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (as an Action) but it is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING or SUCCESS, otherwise returns
  -- FAILURE
  
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.SUCCESS then 
      return twf.actionpath.ActionResult.RUNNING 
    end
    
    return twf.actionpath.ActionResult.FAILURE
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RepeatUntilFailure
  --   print(twf.actionpath.action.RepeatUntilFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RepeatUntilFailure.name()
    return 'twf.actionpath.action.RepeatUntilFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailure.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailure:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailure.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailure.unserialize(serialized, actionPath)
    local serTable = textutils.usnerialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return RepeatUntilFailure:new({child = child})
  end
  
  twf.actionpath.action.RepeatUntilFailure = RepeatUntilFailure
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.Repeater
-- 
-- Repeats the child action either indefinitely or a maximum of some number 
-- of times until the child returns FAILURE. Returns SUCCESS if it reaches
-- the maximum number of times without failure, returns RUNNING while it 
-- reaches that, and returns FAILURE immediately if the child returns failure
--
-- The child returning RUNNING is not counted towards the maximum number of 
-- times
-----------------------------------------------------------------------------
if not twf.actionpath.action.Repeater then
  local Repeater = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  Repeater.child = nil
  
  -----------------------------------------------------------------------------
  -- The number of times to repeat the action, nil for infinite times
  -----------------------------------------------------------------------------
  Repeater.times = nil
  
  -----------------------------------------------------------------------------
  -- The number of times the child action 
  Repeater.counter = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this Repeater
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new(), times = 5})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function Repeater:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    o.times = o.times or 1
    o.counter = o.counter or 0
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns failure if the child returns failure. Returns SUCCESS if the child
  -- has returned SUCCESS the appropriate number of times, and returns RUNNING
  -- otherwise.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function Repeater:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.counter = self.counter + 1
      
      if self.counter == self.times then 
        self.counter = 0
        return twf.actionpath.ActionResult.SUCCESS
      end
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.counter = 0
      return res
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function Repeater:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.Repeater
  --   print(twf.actionpath.action.Repeater.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function Repeater.name()
    return 'twf.actionpath.action.Repeater'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Repeater.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Repeater:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    resultTable.times = self.times
    resultTable.counter = self.counter
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Repeater:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Repeater.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function Repeater.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    local times = serTable.times
    local counter = serTable.counter
    
    return Repeater:new({child = child, times = times, counter = counter})
  end
  
  twf.actionpath.action.Repeater = Repeater
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DieOnFailure
--
-- Crash and burn if the child fails.
--
-- @remarks representative of skydiving
-----------------------------------------------------------------------------
if not twf.actionpath.action.DieOnFailure then
  local DieOnFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DieOnFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DieOnFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DieOnFailure:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, crashes and burns if the 
  -- child returns failure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function DieOnFailure:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    else
      error('World is coming to an end - my child returned ' .. res)
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DieOnFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DieOnFailure
  --   print(twf.actionpath.action.DieOnFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DieOnFailure.name()
    return 'twf.actionpath.action.DieOnFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailure.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailure:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailure.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailure.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return DieOnFailure:new({child = child})
  end
  
  twf.actionpath.action.DieOnFailure = DieOnFailure
end


-----------------------------------------------------------------------------
-- twf.actionpath.action.RetryOnFailure
--
-- Try again if the child fails. Has a small delay before retrying
-----------------------------------------------------------------------------
if not twf.actionpath.action.RetryOnFailure then
  local RetryOnFailure = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RetryOnFailure.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RetryOnFailure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RetryOnFailure:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, and running if the child 
  -- returns failure. Delays for 100ms if the child fails.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function RetryOnFailure:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      os.sleep(0.1)
      return twf.actionpath.ActionResult.RUNNING
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RetryOnFailure:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RetryOnFailure
  --   print(twf.actionpath.action.RetryOnFailure.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RetryOnFailure.name()
    return 'twf.actionpath.action.RetryOnFailure'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailure.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailure:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailure:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailure.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailure.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return RetryOnFailure:new({child = child})
  end
  
  twf.actionpath.action.RetryOnFailure = RetryOnFailure
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.MoveResultInterpreter
--
-- Returns success if the child action returns a successful move result - 
-- managing the interaction between actionpaths twf.movement.action.Action 
-- style classes.
-----------------------------------------------------------------------------
if not twf.actionpath.action.MoveResultInterpreter then
  local MoveResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  MoveResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this MoveResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then
      error('Expected o.child to be a table, but it is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful move result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:perform(stateTurtle, pathState)
    if fs.exists(stateTurtle.actionRecoveryFile) then 
      local moved = stateTurtle:recoverAction()
      if moved then 
        return twf.actionpath.ActionResult.SUCCESS
      end
    end
    
    stateTurtle:prepareAction(self.child)
    local res = self.child:perform(stateTurtle, pathState)
    if twf.movement.MoveResult.isSuccess(res) then 
      self.child:updateState(stateTurtle, pathState)
      return twf.actionpath.ActionResult.SUCCESS
    else 
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.MoveResultInterpreter
  --   print(twf.actionpath.action.MoveResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function MoveResultInterpreter.name()
    return 'twf.actionpath.action.MoveResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreter.unserialize(serialized)
  --
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreter.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return MoveResultInterpreter:new({child = child})
  end
  
  twf.actionpath.action.MoveResultInterpreter = MoveResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DigResultInterpreter
--
-- Returns success if the child action returns a successful dig result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DigResultInterpreter then
  local DigResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DigResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DigResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DigResultInterpreter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful dig result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DigResultInterpreter:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if twf.inventory.DigResult.isSuccess(res) then 
      return twf.actionpath.ActionResult.SUCCESS
    else 
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DigResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DigResultInterpreter
  --   print(twf.actionpath.action.DigResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DigResultInterpreter.name()
    return 'twf.actionpath.action.DigResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreter.unserialize(serialized)
  --
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local act = twf.actionpath.action.DigResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreter.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return DigResultInterpreter:new({child = child})
  end
  
  twf.actionpath.action.DigResultInterpreter = DigResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.PlaceResultInterpreter
--
-- Returns success if the child action returns a successful place result
-----------------------------------------------------------------------------
if not twf.actionpath.action.PlaceResultInterpreter then
  local PlaceResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  PlaceResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this PlaceResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful place result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if twf.inventory.PlaceResult.isSuccess(res) then 
      return twf.actionpath.ActionResult.SUCCESS
    else
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.PlaceResultInterpreter
  --   print(twf.actionpath.action.PlaceResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter.name()
    return 'twf.actionpath.action.PlaceResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreter.unserialize(serialized, actPath)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreter.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath thea ction path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return PlaceResultInterpreter:new({child = child})
  end
  
  twf.actionpath.action.PlaceResultInterpreter = PlaceResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DropResultInterpreter
--
-- Returns success if the child action returns a successful drop result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DropResultInterpreter then
  local DropResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DropResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DropResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DropResultInterpreter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful drop result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DropResultInterpreter:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurle, pathState)
    
    if twf.inventory.DropResult.isSuccess(res) then 
      return twf.actionpath.ActionResult.SUCCESS
    else
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DropResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DropResultInterpreter
  --   print(twf.actionpath.action.DropResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DropResultInterpreter.name()
    return 'twf.actionpath.action.DropResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreter.unserialize(serialized, actPath)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable.child)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreter.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return DropResultInterpreter:new({child = child})
  end
  
  twf.actionpath.action.DropResultInterpreter = DropResultInterpreter
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SuckResultInterpreter
--
-- Returns success if the child action returns a successful suck result
-----------------------------------------------------------------------------
if not twf.actionpath.action.SuckResultInterpreter then
  local SuckResultInterpreter = {}
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  SuckResultInterpreter.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SuckResultInterpreter
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action), but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful suck result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:perform(stateTurtle, pathState)
    local res = self.child:perform(stateTurtle, pathState)
    
    if twf.inventory.SuckResult.isSuccess(res) then 
      return twf.actionpath.ActionResult.SUCCESS
    else
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SuckResultInterpreter
  --   print(twf.actionpath.action.SuckResultInterpreter.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SuckResultInterpreter.name()
    return 'twf.actionpath.action.SuckResultInterpreter'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreter.unserialize(serialized, actPath)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreter:serialize(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializeAction(self.child)
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreter:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreter.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreter.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    local child = actionPath:unserializeAction(serTable.child)
    
    return SuckResultInterpreter:new({child = child})
  end
  
  twf.actionpath.action.SuckResultInterpreter = SuckResultInterpreter
end

-- Leafs

-----------------------------------------------------------------------------
-- twf.actionpath.action.FuelCheckAction
--
-- Checks if the fuel is above a certain level. If it is, returns SUCCESS 
-- otherwise returns FAILURE
-----------------------------------------------------------------------------
if not twf.actionpath.action.FuelCheckAction then
  local FuelCheckAction = {}
  
  -----------------------------------------------------------------------------
  -- The minimum fuel level to return SUCCESS (inclusive)
  -----------------------------------------------------------------------------
  FuelCheckAction.fuelLevel = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this FuelCheckAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.fuelLevel is nil or negative
  -----------------------------------------------------------------------------
  function FuelCheckAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.fuelLevel) ~= 'number' then 
      error('Expected o.fuelLevel to be a number but was ' .. type(o.fuelLevel))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has at least the specified amount of fuel, 
  -- otherwise returns failuer
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function FuelCheckAction:perform(stateTurtle, pathState)
    local succ = turtle.getFuelLevel() >= self.fuelLevel
    
    if succ then 
      return twf.actionpath.ActionResult.SUCCESS
    else 
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function FuelCheckAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.FuelCheckAction
  --   print(twf.actionpath.action.FuelCheckAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function FuelCheckAction.name()
    return 'twf.actionpath.action.FuelCheckAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.fuelLevel = self.fuelLevel
    
    return textutils.serialize(resultTable.fuelLevel)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({fuelLevel = 5})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local fuelLevel = serTable.fuelLevel 
    
    return FuelCheckAction:new({fuelLevel = fuelLevel})
  end
  
  twf.actionpath.action.FuelCheckAction = FuelCheckAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.InventoryCheckAction
--
-- Checks if there is some amount of some item (or any amount or any item) in
-- a specific slot or range of slots
-----------------------------------------------------------------------------
if not twf.actionpath.action.InventoryCheckAction then
  local InventoryCheckAction = {}
  
  -----------------------------------------------------------------------------
  -- The item detail to search for. 'any' indicates any item
  -- 
  -- Serialized examples:
  --   { name = 'any', count = 1 }
  --   { name = 'minecraft:log', damage = 2, count = 1 }
  -----------------------------------------------------------------------------
  InventoryCheckAction.item = nil
  
  -----------------------------------------------------------------------------
  -- The slots to search in, as a table. 'any' indicates any slot.
  --
  -- Serialized examples:
  --   'any'
  --   { 1, 2, 3, 4 }
  --   { 16 }
  -----------------------------------------------------------------------------
  InventoryCheckAction.slots = nil
  
  -----------------------------------------------------------------------------
  -- True for strict, false for lenient item checking. Ignored for 'any' item
  -----------------------------------------------------------------------------
  InventoryCheckAction.strict = false
  
  -----------------------------------------------------------------------------
  -- A string constant:
  --   'none'    - Does not check count at all
  --   'minimum' - Success if there's at least the items count number of items. 
  --   'exact'   - Success if the count matches exactly the item count.
  --   'maximum' - Success if theres at most the items count number of items
  -----------------------------------------------------------------------------
  InventoryCheckAction.countCheck = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this InventoryCheckAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.item is nil or o.item.name is nil or o.item.count is nil or 
  --          o.item.name is not 'any' and o.item.damage is nil
  -- @error   if o.slots is nil or o.slots is not 'any' or a table with at 
  --          least one number
  -- @error   if o.countCheck is not either 'none', 'minimum', 'exact', or
  --          'maximum'
  -----------------------------------------------------------------------------
  function InventoryCheckAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.item) ~= 'table' then 
      error('Expected o.item to be a table but is ' .. type(o.item))
    end
    
    if type(o.item.name) ~= 'string' then 
      error('Expected o.item.name to be a string but is ' .. type(o.item.name))
    end
    
    if type(o.item.count) ~= 'number' then 
      error('Expected o.item.count to be a number but is ' .. type(o.item.count))
    end
    
    if o.item.name ~= 'any' and type(o.item.damage) ~= 'number' then 
      error('If o.item.name (is ' .. o.item.name .. ') is not \'any\' then o.item.damage should be a number but is ' .. type(o.item.damage))
    end
    
    if type(o.slots) == 'string' then 
      if o.slots ~= 'any' then 
        error('If o.slots is a string then it must be \'any\' but is \'' .. o.slots .. '\'')
      end
    elseif type(o.slots) == 'table' then 
      if #o.slots < 1 then 
        error('Expected o.slots to be a table with at least 1 number in it, but is ' .. textutils.serialize(o.slots))
      end
      
      for i = 1, #o.slots do
        if type(o.slots[i]) ~= 'number' then 
          error('o.slots should only contain numbers, but o.slots[' .. i .. '] is ' .. type(o.slots[i]))
        end
      end
    else 
      error('Expected o.slots to be a table or string but is ' .. type(o.slots))
    end
    
    local countCheckIsValid =                o.countCheck == 'none'
    countCheckIsValid = countCheckIsValid or o.countCheck == 'minimum'
    countCheckIsValid = countCheckIsValid or o.countCheck == 'exact'
    countCheckIsValid = countCheckIsValid or o.countCheck == 'maximum'
    
    if not countCheckIsValid then 
      error('Expected o.countCheck to be \'none\', \'minimum\', \'exact\', or \'maximum\' but is \'' .. o.countCheck .. '\'')
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Checks if the specified item matches this inventory check actions item 
  -- requirements (not including count or slot)
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --   local item = twf.inventory.ItemDetail:new({name = 'minecraft:log', damage = 1, count = 32})
  --   local res = act:itemMatches(item)
  --   -- prints true
  --   print(res)
  --
  -- @param itemDetail twf.inventory.ItemDetail item detail to check
  -- @return boolean true if the itemDetail fits the bill, false otherwise
  -----------------------------------------------------------------------------
  function InventoryCheckAction:itemMatches(itemDetail)
    if itemDetail == nil then return false end
    
    if self.item.name == 'any' then 
      return true
    end
    
    if self.item.name ~= itemDetail.name then return false end
    if strict and self.item.damage ~= itemDetail.damage then return false end
    
    return true
  end
  
  -----------------------------------------------------------------------------
  -- Creates a copy of the state turtles inventory, will all of the slots that 
  -- should not be checked by this inventory check action emptied.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   st:loadInventoryFromTurtle()
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --   local res = act:inventoryForSlots(st)
  --   -- Will print an inventory with slots 1-15 empty, regardless of the real
  --   -- inventoy of the turtle
  --   print(res:toString())
  --
  -- @param stateTurtle the state turtle
  -- @return clone of turtles inventory, with irrelevant slots emptied
  -----------------------------------------------------------------------------
  function InventoryCheckAction:inventoryForSlots(stateTurtle)
    local inv = stateTurtle.inventory:clone()
    
    if self.slots == 'any' then 
      return inv 
    end
    
    for i = 1, 16 do 
      local allowed = false
      for j = 1, #slots do 
        if slots[j] == i then 
          allowed = true
          break
        end
      end
      
      if not allowed then 
        inv.setItemDetailAt(i, nil)
      end
    end
    
    return inv
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the turtle has the specified items in the specified 
  -- slots
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.InventoryCheckAction:new(
  --     {
  --       item = { name = 'any', count = 64 },
  --       slots = { 16 },
  --       countCheck = 'exact' 
  --     })
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function InventoryCheckAction:perform(stateTurtle, pathState)
    local relevantInventory = self:inventoryForSlots(stateTurtle)
    local totalCount = 0
    
    for i = 1, 16 do 
      local item = relevantInventory.getItemDetailAt(i)
      
      if item and self:itemMatches(item) then 
        totalCount = totalCount + item.count
      end
    end
    
    local succ = false
    if self.countCheck == 'none' then 
      succ = totalCount > 0 
    elseif self.countCheck == 'minimum' then 
      succ = totalCount > self.item.count
    elseif self.countCheck == 'exact' then 
      succ = totalCount == self.item.count
    elseif self.countCheck == 'maximum' then 
      succ = totalCount < self.item.count
    else 
      error('Unexpected countcheck ' .. self.countCheck)
    end
    
    if succ then 
      return twf.actionpath.ActionResult.SUCCESS
    else
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function InventoryCheckAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.InventoryCheckAction
  --   print(twf.actionpath.action.InventoryCheckAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function InventoryCheckAction.name()
    return 'twf.actionpath.action.InventoryCheckAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({items = 'any', slots = 'any'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.items = self.items
    resultTable.slots = self.slots
    resultTable.countCheck = self.countCheck
    resultTable.strict = self.strict
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({items = 'any', slots = 'any'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local items = serTable.items
    local slots = serTable.slots
    local countCheck = serTable.countCheck
    local strict = serTable.strict
    
    return InventoryCheckAction:new({items = items, slots = slots, countCheck = countCheck, strict = strict})
  end
  
  twf.actionpath.action.InventoryCheckAction = InventoryCheckAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.InventorySelectAction
--
-- Selects a slot in the turtles inventory
-----------------------------------------------------------------------------
if not twf.actionpath.action.InventorySelectAction then
  local InventorySelectAction = {}
  
  -----------------------------------------------------------------------------
  -- The index of the slot to select
  -----------------------------------------------------------------------------
  InventorySelectAction.slotIndex = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this InventorySelectAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.slotIndex is nil or not on [1, 16]
  -----------------------------------------------------------------------------
  function InventorySelectAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.slotIndex) ~= 'number' then 
      error('Expected o.slotIndex to be a number but is ' .. type(o.slotIndex))
    end
    
    if o.slotIndex < 1 or o.slotIndex > 16 then 
      error('Expected o.slotIndex to be on the interval [1, 16] but is ' .. o.slotIndex)
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Selects the specified slot
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function InventorySelectAction:perform(stateTurtle, pathState)
    turtle.select(self.slotIndex)
    stateTurtle.selectedSlot = self.slotIndex
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function InventorySelectAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.InventorySelectAction
  --   print(twf.actionpath.action.InventorySelectAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function InventorySelectAction.name()
    return 'twf.actionpath.action.InventorySelectAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.slotIndex = self.slotIndex
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local slotIndex = serTable.slotIndex
    
    return InventorySelectAction:new({slotIndex = slotIndex})
  end
  
  twf.actionpath.action.InventorySelectAction = InventorySelectAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DropAction
-- 
-- Like twf.inventory.action.DropAction, except allows specifying either one
-- or more item slots, or one or more ItemDetails
-----------------------------------------------------------------------------
if not twf.actionpath.action.DropAction then
  local DropAction = {}
  
  -----------------------------------------------------------------------------
  -- Describes what method is being used to decide what to drop, one of the 
  -- following:
  --   'slot'           - Dropping by slot indexes
  --   'item'           - Dropping specific items and specific maximum amounts
  --   'itemType'       - Dropping a specific type of items
  --   'exceptItemType' - Dropping everything *except* a specific item type
  --   'all'            - Dropping everything the turtle has
  -----------------------------------------------------------------------------
  DropAction.dropBy = nil
  
  -----------------------------------------------------------------------------
  -- The direction to drop items in
  -----------------------------------------------------------------------------
  DropAction.direction = nil
  
  -----------------------------------------------------------------------------
  -- What slots to drop, if the dropBy is 'slot'.
  -- Examples:
  --   {1, 2, 3}
  --   {16}
  -----------------------------------------------------------------------------
  DropAction.slots = nil
  
  -----------------------------------------------------------------------------
  -- What items (or types of items) to drop, if the dropBy is item or itemType
  -- What items not to drop if dropBy is exceptItemType
  -- Examples:
  --   { {name = 'minecraft:log', damage = 1, count = 32} }
  -----------------------------------------------------------------------------
  DropAction.items = nil
  
  -----------------------------------------------------------------------------
  -- If item types should be compared strictly or not. Ignored if the dropBy 
  -- is not 'item' 'itemType', or 'exceptItemType'
  -----------------------------------------------------------------------------
  DropAction.itemStrict = false
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DropAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new(
  --     {dropBy = 'all', direction = twf.movement.direction.FORWARD})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.dropBy is nil or not 'slot', 'item', 'itemType', 
  --         'exceptItemType' or 'all'
  -- @error   if o.dropBy is 'slot' and o.slots is nil or empty
  -- @error   if o.dropBy is 'item', 'itemType' 'exceptItemType' and o.items is
  --          nil or empty
  -- @error   if o.direction is not FORWARD, UP, or DOWN
  -----------------------------------------------------------------------------
  function DropAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.dropBy) ~= 'string' then 
      error('Expected o.dropBy to be a string but is ' .. type(o.dropBy))
    end
    
    local dropByValid =          o.dropBy == 'slot'
    dropByValid = dropByValid or o.dropBy == 'item'
    dropByValid = dropByValid or o.dropBy == 'itemType'
    dropByValid = dropByValid or o.dropBy == 'exceptItemType'
    dropByValid = dropByValid or o.dropBy == 'all'
    
    if not dropByValid then 
      error('Expected o.dropBy to be \'slot\', \'item\', \'itemType\', \'exceptItemType\' or \'all\' but is ' .. o.dropBy)
    end
    
    if o.dropBy == 'slot' then 
      if type(o.slots) ~= 'table' then 
        error('Expected o.slots to be a table since o.dropBy is \'slot\' but o.slots is ' .. type(o.slots))
      end
      
      if #o.slots < 1 then 
        error('Expected o.slots to have something in it since o.dropBy is \'slot\' but o.slots is empty')
      end
      
      for i = 1, #o.slots do 
        if type(o.slots[i]) ~= 'number' then 
          error('Expected o.slots to be a table of numbers, but type(o.slots[' .. i .. ']) = ' .. type(o.slots[i]))
        end
      end
    end
    
    if o.dropBy == 'item' or o.dropBy == 'itemType' or o.dropBy == 'exceptItemType' then 
      if type(o.items) ~= 'table' then 
        error('Since o.dropBy is \'' .. o.dropBy .. '\', expected o.items to be a table but o.items is ' .. type(o.items))
      end
      
      if #o.items < 1 then 
        error('Since o.dropBy is \'' .. o.dropBy .. '\', expected o.items to be a table with content, but o.items is empty!')
      end
    end
    
    local dirIsValid =         o.direction == twf.movement.direction.FORWARD 
    dirIsValid = dirIsValid or o.direction == twf.movement.direction.UP 
    dirIsValid = dirIsValid or o.direction == twf.movement.direction.DOWN 
    
    if not dirIsValid then 
      error('Expected o.direction to be FORWARD, UP, or DOWN but is ' .. o.direction)
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Drops a maximum of the specified amount for the current slot. Normally for 
  -- internal use
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'slot', 
  --     slots = { 16 }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:drop(st, {})
  --
  -- @param stateTurtle the stateful turtle
  -- @param pathState the current state of the action path
  -- @param amount (optional) maximum number to drop 
  -- @return twf.actionpath.ActionResult, twf.inventory.ItemDetail success 
  --         if any items are dropped, failure otherwise. The item detail is 
  --         for what items were dropped, if any
  -----------------------------------------------------------------------------
  function DropAction:drop(stateTurtle, pathState, amount)
    local delegate = twf.inventory.action.DropAction:new({direction = self.direction, amount = amount})
    local res, item = delegate:perform(stateTurtle, pathState)
    
    if twf.inventory.DropResult.isSuccess(res) then 
      return twf.actionpath.ActionResult.SUCCESS, item
    else 
      return twf.actionpath.ActionResult.FAILURE, item
    end
  end
  
  -----------------------------------------------------------------------------
  -- Drops items by slot. Normally for internal use.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action, twf.movement.action, twf.inventory.action)
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'slot', 
  --     slots = { 16 }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:dropBySlot(st, actPath.pathState)  
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return twf.actionpath.ActionResult
  -----------------------------------------------------------------------------
  function DropAction:dropBySlot(stateTurtle, pathState)
    for i = 1, #slots do 
      stateTurtle:selectSlot(slots[i])
      
      local res, item = self:drop(stateTurtle, pathState)
      if res == twf.actionpath.ActionResult.FAILURE then 
        return res
      end
    end
    
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- Drops items with the 'item' dropBy type. Normally for internal use.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action, twf.movement.action, twf.inventory.action)
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'item', 
  --     items = { {name = 'minecraft:log', damage = 1, count = 32} }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:dropByItem(st, actPath.pathState)  
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return twf.actionpath.ActionResult success if expected number of items
  --         are dropped, failure otherwise
  -----------------------------------------------------------------------------
  function DropAction:dropByItem(stateTurtle, pathState)
    for i = 1, #self.items do 
      local toDrop = self.items[i].count
      local nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      
      while nextIndex > 0 and toDrop > 0 do 
        stateTurtle:selectSlot(nextIndex)
        
        local res, item = self:drop(stateTurtle, pathState, toDrop)
        
        if res == twf.actionpath.ActionResult.FAILURE then 
          return res
        end
        
        if not item then 
          error('Weird state, res is failure but item is nil!')
        end
        
        toDrop = toDrop - item.count
        nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      end
    end
    
    return twf.actionpath.ActionResult.SUCCESS
  end
 
  -----------------------------------------------------------------------------
  -- Drops items with the 'itemType' dropBy type. Normally for internal use.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action, twf.movement.action, twf.inventory.action)
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'itemType', 
  --     items = { {name = 'minecraft:log', damage = 1, count = 1} }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:dropByItemType(st, actPath.pathState)  
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return twf.actionpath.ActionResult success if expected number of items 
  --         are dropped, failure otherwise
  -----------------------------------------------------------------------------
  function DropAction:dropByItemType(stateTurtle, pathState)
    for i = 1, #self.items do 
      local nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      
      while nextIndex > 0 do 
        stateTurtle:selectSlot(nextIndex)
        
        local res, item = self:drop(stateTurtle, pathState, toDrop)
        
        if res == twf.actionpath.ActionResult.FAILURE then 
          return res
        end
        
        nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      end
    end
    
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  
  -----------------------------------------------------------------------------
  -- Drops items with the 'exceptItemType' dropBy type. Normally for internal 
  -- use.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action, twf.movement.action, twf.inventory.action)
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'exceptItemType', 
  --     items = { {name = 'minecraft:log', damage = 1, count = 1} }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:dropByExceptItemType(st, actPath.pathState)  
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return twf.actionpath.ActionResult success if expected number of items
  --         are dropped, failure otherwise
  -----------------------------------------------------------------------------
  function DropAction:dropByExceptItemType(stateTurtle, pathState)
    for i = 1, 16 do 
      local item = stateTurtle.getItemDetailAt(i)
      
      if item then 
        local skip = false
        if self.itemStrict then 
          for j = 1, #items do 
            skip = item:lenientItemEquals(items[j])
            if skip then break end
          end
        else 
          for j = 1, #items do 
            skip = item:strictItemEquals(items[j])
            if skip then break end 
          end
        end
        
        if not skip then 
          stateTurtle:selectSlot(i)
          local res, item = self:drop()
          
          if res == twf.actionpath.ActionResult.FAILURE then 
            return res 
          end
        end
      end
    end
    
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- Drops items with the 'all' dropBy type. Normally for internal use.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action, twf.movement.action, twf.inventory.action)
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'all',  
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   act:dropByAll(st, actPath.pathState)  
  --
  -- @param stateTurtle the state turtle
  -- @param pathState the path state
  -- @return twf.actionpath.ActionResult success if expected number of items
  --         are dropped, failure otherwise
  -----------------------------------------------------------------------------
  function DropAction:dropByAll(stateTurtle, pathState)
    local nextIndex = stateTurtle.inventory:firstIndexOfFilledSlot()
    
    while nextIndex > 0 do 
      stateTurtle:selectSlot(nextIndex)
      local res, item = self:drop()
      
      if res == twf.actionpath.ActionResult.FAILURE then 
        return res
      end
      
      nextIndex = stateTurtle.inventory:firstIndexOfFilledSlot()
    end
    
    return twf.actionpath.ActionResult.FAILURE
  end
  
  -----------------------------------------------------------------------------
  -- Drops the appropriate items/slots. Returns failure if less than the 
  -- expected items are dropped for the turtles starting inventory. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropAction:new({
  --     dropBy = 'slot', 
  --     slots = { 16 }, 
  --     direction = twf.movement.direction.FORWARD
  --   })
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DropAction:perform(stateTurtle, pathState)
    if     self.dropBy == 'slot'           then return self:dropBySlot(stateTurtle, pathState)
    elseif self.dropBy == 'item'           then return self:dropByItem(stateTurtle, pathState)
    elseif self.dropBy == 'itemType'       then return self:dropByItemType(stateTurtle, pathState)
    elseif self.dropBy == 'exceptItemType' then return self:dropByExceptItemType(stateTurtle, pathState)
    elseif self.dropBy == 'all'            then return self:dropByAll(stateTurtle, pathState)
    else error('Unexpected dropBy: ' .. self.dropBy) end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  --
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DropAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DropAction
  --   print(twf.actionpath.action.DropAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DropAction.name()
    return 'twf.actionpath.action.DropAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction:serialize(actionPath)
    local resultTable = {}
    
    resultTable.dropBy = self.dropBy
    resultTable.direction = self.direction
    resultTable.slots = self.slots
    
    if self.items then 
      resultTable.items = {}
      for i = 1, #self.items do 
        resultTable.items[i] = self.items[i]:serialize()
      end
    end
    
    resultTable.itemStrict = self.itemStrict
    
    return textutils.serialize(resultTable)
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({slotIndex = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction.unserialize(serialized)
    local serTable = textutils.unserialize(serialized)
    
    local dropBy = serTable.dropBy
    local direction = serTable.direction
    local slots = serTable.slots
    
    local items = nil
    if serTable.items then 
      items = {}
      for i = 1, #serTable.items do 
        items[i] = twf.inventory.ItemDetail.unserialize(serTable.items[i])
      end
    end
    
    local itemStrict = serTable.itemStrict 
    
    return DropAction:new({
      dropBy = dropBy,
      direction = direction,
      slots = slots,
      items=  items,
      itemStrict = itemStrict
    })
  end
  
  twf.actionpath.action.DropAction = DropAction
end