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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  Action.logFile = nil
  
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
  -- Guarranteed to be called at least once before perform. The log file should
  -- be set to all of the actions children
  --
  -- @param logFile file handle
  -----------------------------------------------------------------------------
  function Action:setLogFile(logFile)
    error('Action:setLogFile(logFile) should not be called!')
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
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function Action:serializableObject(actionPath)
    error('Action:serializableObject(actionPath) should not be called directly!')
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function Action.unserializeObject(serialized, actionPath)
    error('Action:unserializeObject(serialized) should not be called directly!')
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
  -- The log file handle for this action path
  -----------------------------------------------------------------------------
  ActionPath.logFile = nil
  
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
  -----------------------------------------------------------------------------
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
  -- Initializes the actionpath with the specified log file handle.
  --
  -- @param logFile the log file, may be nil
  -----------------------------------------------------------------------------
  function ActionPath:setLogFile(logFile)
    self.logFile = logFile
    self.head:setLogFile(logFile)
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
  -- 
  -- @param stateTurtle the stateful turtle
  -- @return result of head action
  -----------------------------------------------------------------------------
  function ActionPath:tick(stateTurtle)
    local result = self.head:perform(stateTurtle, self.pathState)
    
    if result == twf.actionpath.ActionResult.SUCCESS then 
      self.head:updateState(stateTurtle, self.pathState)
    end
    
    return result
  end
  
  -----------------------------------------------------------------------------
  -- Serializes the action into an object form 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializableObjectForAction(act)
  --   local unserialized = actPath:unserializeObjectOfAction(serialized)
  --
  -- @param action the action to serialize into an object
  -- @return       object serialization of the action
  -----------------------------------------------------------------------------
  function ActionPath:serializableObjectForAction(action)
    local resultTable = {}
    
    resultTable.name = action.name()
    resultTable.action = action:serializableObject(self)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by serializableObjectForAction
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local actPath = twf.actionpath.ActionPath:new()
  --   actPath:registerActions(twf.actionpath.action)
  --   local act = twf.actionpath.action.FuelCheckAction({fuelLevel = 5})
  --   local serialized = actPath:serializableObjectForAction(act)
  --   local unserialized = actPath:unserializeObjectOfAction(serialized)
  --
  -- @param serialized the serialized object
  -- @return serialized action
  -----------------------------------------------------------------------------
  function ActionPath:unserializeObjectOfAction(serObj)
    local name = serObj.name
    local serAction = serObj.action
    
    for i = 1, #self.registeredActions do 
      local act = self.registeredActions[i]
      if act.name() == name then 
        return act.unserializeObject(serAction, self)
      end
    end
    
    error('Unknown action type ' .. name)
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
    return textutils.serialize(self:serializableObjectForAction(action))
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
    
    return self:unserializeObjectOfAction(serTable)
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this actionpath 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serializableObject()
  --   local unserialized = twf.actionpath.action.Action.unserializeObject(serialized)
  --
  -- @return object serialization of this action
  -----------------------------------------------------------------------------
  function ActionPath:serializableObject()
    local resultTable = {}
    
    resultTable.head = self:serializableObjectForAction(self.head)
    resultTable.pathState = self.pathState
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.ActionPath:new()
  --   local serialized = act:serializableObject()
  --   local unserialized = twf.actionpath.action.ActionPath.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -----------------------------------------------------------------------------
  function ActionPath:unserializeObject(serTable)
    self.head = self:unserializeObjectOfAction(serTable.head)
    self.pathState = serTable.pathState
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
    return textutils.serialize(self:serializableObject())
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
    self:unserializeObject(textutils.unserialize(serialized))
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
  --   This function will normally never return if repeatForever is true
  --
  -- @param actionPath         the action path prepared with the necessary 
  --                           actions for loading.
  -- @param actionPathFilePref actionPathFile where the action file is saved 
  --                           normally. Postfixed with .actionpath
  -- @param actPathStatePrefix prefix for the action path state.
  --                           Postfixed with _recovery.dat
  -- @param repeatForever      (optional) default true - if this action path 
  --                           should be continuously ticked, forever.
  -- @see                      twf.actionpath.ActionPath
  -----------------------------------------------------------------------------
  function StatefulTurtle:executeActionPath(actionPath, actionPathFilePref, actPathStatePrefix, repeatForever)
    if repeatForever == nil then repeatForever = true end
    
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
    
    local logFile = fs.open('actionpath.log', fs.exists('actionpath.log') and 'w' or 'a')
    logFile.writeLine('executeActionPath begin')
    actionPath:setLogFile(logFile)
    while true do 
      logFile.writeLine('--------- TICK BEGIN ---------')
      local tickSuccess, res = pcall(actionPath.tick, actionPath, self)
      logFile.writeLine('--------- TICK END ---------')
      if not tickSuccess then 
        logFile.writeLine('tick failed! ' .. res)
        logFile.close()
        error(res)
      end
      actionPath:saveToFile(actionPathRecoveryFile)
      self:saveToFile()
      self:finishAction()
      
      -- Yielding here will make it slightly more likely to be 
      -- unloaded here, which is pretty much guarranteed to work
      os.queueEvent("twfFakeEventName")
      os.pullEvent("twfFakeEventName")
      
      if res ~= twf.actionpath.ActionResult.RUNNING then 
        if not repeatForever then break end
      end
    end
    actionPath:setLogFile(nil)
    logFile.close()
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  SequenceAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function SequenceAction:setLogFile(logFile)
    self.logFile = logFile
    for _, child in ipairs(self.children) do
      if type(child.setLogFile) == 'function' then 
        child:setLogFile(logFile)
      end
    end
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
    self.logFile.writeLine('SequenceAction start')
    local child = self.children[self.currentIndex]
    self.logFile.writeLine('SequenceAction ticking child #' .. self.currentIndex .. ' (' .. child.name().. ')')
    local res = child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then      
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex > #self.children then 
        self.currentIndex = 1
        self.logFile.writeLine('SequenceAction child returned success, no more children. Returning success')
        return res
      end
      
      self.logFile.writeLine('SequenceAction child returned success, still have children left. Returning running')
      return twf.actionpath.ActionResult.RUNNING
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('SequenceAction child returned running. Returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('SequenceAction child returned failure. Returning failure')
      self.currentIndex = 1
      return res
    end
    
    error('Should not get here (res = ' .. res .. ')')
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
  --   local act = twf.actionpath.action.SequenceAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SequenceAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      local succ, err = pcall(function()
        resultTable.children[i] = actionPath:serializableObjectForAction(self.children[i])
      end)
      
      if not succ then 
        error('Failed to serialize ' .. self.children[i].name() .. ': ' .. err)
      end
    end
    
    resultTable.currentIndex = self.currentIndex
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SequenceAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SequenceAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function SequenceAction.unserializeObject(serTable, actionPath)
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeObjectOfAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    
    return SequenceAction:new({children = children, currentIndex = currentIndex})
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
    textutils.serialize(self:serializableObject(actionPath))
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
    
    return SequenceAction.unserializeObject(serTable, actionPath)
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  SelectorAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function SelectorAction:setLogFile(logFile)
    self.logFile = logFile
    for _, child in ipairs(self.children) do
      if type(child.setLogFile) == 'function' then 
        child:setLogFile(logFile)
      end
    end
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
    self.logFile.writeLine('SelectorAction start')
    local child = self.children[self.currentIndex]
    self.logFile.writeLine('SelectorAction ticking child #' .. self.currentIndex .. ' (' .. child.name() .. ')')
    local res = child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.currentIndex = 1
      self.logFile.writeLine('SelectorAction child returned success, returning success')
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('SelectorAction child returned running, returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.currentIndex = self.currentIndex + 1 
      if self.currentIndex > #self.children then 
        self.currentIndex = 1
        self.logFile.writeLine('SelectorAction child returned failure, no more children. Returning failure')
        return res
      end
      
      self.logFile.writeLine('SelectorAction child returning failure, still have more children. Returning running')
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
  --   local act = twf.actionpath.action.SelectorAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SelectorAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      resultTable.children[i] = actionPath:serializableObjectForAction(self.children[i])
    end
    
    resultTable.currentIndex = self.currentIndex
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SelectorAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SelectorAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function SelectorAction.unserializeObject(serTable, actionPath)
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeObjectOfAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    
    return SelectorAction:new({children = children, currentIndex = currentIndex})
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
    textutils.serialize(self:serializableObject(actionPath))
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
    
    return SelectorAction.unserializeObject(serTable, actionPath)
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  RandomSelectorAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function RandomSelectorAction:setLogFile(logFile)
    self.logFile = logFile
    for _, child in ipairs(self.children) do
      if type(child.setLogFile) == 'function' then 
        child:setLogFile(logFile)
      end
    end
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
    self.logFile.writeLine('RandomSelectorAction start')
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
      choiceIndex = remainingOptions[optionsIndex]
      self.bannedIndexes[#self.bannedIndexes + 1] = choiceIndex
    else 
      self.logFile.writeLine('RandomSelectorAction repeating last choice')
      choiceIndex = self.currentIndex
    end
    
    local choice = self.children[choiceIndex]
    self.logFile.writeLine('RandomSelectorAction selected child #' .. choiceIndex .. ' (' .. choice.name() .. ')')
    local res = choice:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.bannedIndexes = {}
      self.currentIndex = nil
      self.logFile.writeLine('RandomSelectorAction child returned success, returning success')
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.currentIndex = choiceIndex
      self.logFile.writeLine('RandomSelectorAction child returned running, returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.currentIndex = nil
      if #self.bannedIndexes == #self.children then 
        self.bannedIndexes = {}
        self.logFile.writeLine('RandomSelectorAction child returned failure. No children left. Returning failure')
        return twf.actionpath.ActionResult.FAILURE
      else
        self.logFile.writeLine('RandomSelectorAction child returned failure, still have children left. Returning running')
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
  --   local act = twf.actionpath.action.RandomSelectorAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RandomSelectorAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.children = {}
    
    for i = 1, #self.children do 
      resultTable.children[i] = actionPath:serializableObjectForAction(self.children[i])
    end
    
    resultTable.currentIndex = self.currentIndex
    resultTable.bannedIndexes = self.bannedIndexes
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RandomSelectorAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RandomSelectorAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function RandomSelectorAction.unserializeObject(serTable, actionPath)
    local children = {}
    
    for i = 1, #serTable.children do 
      children[i] = actionPath:unserializeObjectOfAction(serTable.children[i])
    end
    
    local currentIndex = serTable.currentIndex
    local bannedIndexes = serTable.bannedIndexes
    
    return RandomSelectorAction:new({children = children, currentIndex = currentIndex, bannedIndexes = bannedIndexes})
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
    textutils.serialize(self:serializableObject(actionPath))
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
    
    return RandomSelectorAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.RandomSelectorAction = RandomSelectorAction
end

-- Decorators

-----------------------------------------------------------------------------
-- twf.actionpath.action.InverterAction
--
-- Inverts the result of the child - FAILURE -> SUCCESS, RUNNING -> RUNNING, 
-- and SUCCESS -> FAILURE
-----------------------------------------------------------------------------
if not twf.actionpath.action.InverterAction then
  local InverterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  InverterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this inverter
  -----------------------------------------------------------------------------
  InverterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this InverterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InverterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function InverterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function InverterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns the inverted result of the child
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.InverterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function InverterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('InverterAction start')
    self.logFile.writeLine('InverterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.logFile.writeLine('InverterAction child returned success, returning failure')
      return twf.actionpath.ActionResult.FAILURE 
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('InverterAction child returned running, returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('InverterAction child returned failure, returning success')
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
  function InverterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.InverterAction
  --   print(twf.actionpath.action.InverterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function InverterAction.name()
    return 'twf.actionpath.action.InverterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InverterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InverterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InverterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InverterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InverterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function InverterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return InverterAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InverterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InverterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InverterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InverterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InverterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InverterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return InverterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.InverterAction = InverterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SucceederAction
--
-- Except for RUNNING which is unaffected, always returns SUCCESS
-----------------------------------------------------------------------------
if not twf.actionpath.action.SucceederAction then
  local SucceederAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  SucceederAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this succeeder
  -----------------------------------------------------------------------------
  SucceederAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SucceederAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SucceederAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function SucceederAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (as an Action) but it is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function SucceederAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING, otherwise returns SUCCESS
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SucceederAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SucceederAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('SucceederAction start')
    self.logFile.writeLine('SucceederAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('SucceederAction child returned running, returning running')
      return res
    end
    
    self.logFile.writeLine('SucceederAction child didn\'t return running - returning success')
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SucceederAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SucceederAction
  --   print(twf.actionpath.action.SucceederAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SucceederAction.name()
    return 'twf.actionpath.action.SucceederAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SucceederAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SucceederAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SucceederAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SucceederAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SucceederAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function SucceederAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return SucceederAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SucceederAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SucceederAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SucceederAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SucceederAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SucceederAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SucceederAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return SucceederAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.SucceederAction = SucceederAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RepeatUntilFailureAction
-- 
-- Repeats the child action until it returns failure
-----------------------------------------------------------------------------
if not twf.actionpath.action.RepeatUntilFailureAction then
  local RepeatUntilFailureAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  RepeatUntilFailureAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RepeatUntilFailureAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RepeatUntilFailureAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (as an Action) but it is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns RUNNING if the child returns RUNNING or SUCCESS, otherwise returns
  -- FAILURE
  
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('RepeatUntilFailureAction start')
    self.logFile.writeLine('RepeatUntilFailureAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('RepeatUntilFailureAction child returned running - returning running')
      return res
    elseif res == twf.actionpath.ActionResult.SUCCESS then 
      self.logFile.writeLine('RepeatUntilFailureAction child returned success - returning running')
      return twf.actionpath.ActionResult.RUNNING 
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('RepeatUntilFailureAction child returned failure - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
    
    error('Should not get here')
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RepeatUntilFailureAction
  --   print(twf.actionpath.action.RepeatUntilFailureAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction.name()
    return 'twf.actionpath.action.RepeatUntilFailureAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailureAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailureAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return RepeatUntilFailureAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailureAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeatUntilFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeatUntilFailureAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeatUntilFailureAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return RepeatUntilFailureAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.RepeatUntilFailureAction = RepeatUntilFailureAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.RepeaterAction
-- 
-- Repeats the child action either indefinitely or a maximum of some number 
-- of times until the child returns FAILURE. Returns SUCCESS if it reaches
-- the maximum number of times without failure, returns RUNNING while it 
-- reaches that, and returns FAILURE immediately if the child returns failure
--
-- The child returning RUNNING is not counted towards the maximum number of 
-- times
-----------------------------------------------------------------------------
if not twf.actionpath.action.RepeaterAction then
  local RepeaterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  RepeaterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RepeaterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- The number of times to repeat the action, nil for infinite times
  -----------------------------------------------------------------------------
  RepeaterAction.times = nil
  
  -----------------------------------------------------------------------------
  -- The number of times the child action 
  RepeaterAction.counter = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RepeaterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.action.ActionName:new(), times = 5})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RepeaterAction:new(o)
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function RepeaterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns failure if the child returns failure. Returns SUCCESS if the child
  -- has returned SUCCESS the appropriate number of times, and returns RUNNING
  -- otherwise.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function RepeaterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('RepeaterAction start')
    self.logFile.writeLine('RepeaterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.counter = self.counter + 1
      
      if self.counter == self.times then 
        self.counter = 0
        self.logFile.writeLine('RepeaterAction child returned success - finished repeating ' .. self.times .. ' times - returning success')
        return twf.actionpath.ActionResult.SUCCESS
      end
      self.logFile.writeLine('RepeaterAction child returned success, finished ' .. self.counter .. '/' .. self.times .. ' - returning running')
      return twf.actionpath.ActionResult.RUNNING
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('RepeaterAction child returned running - returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('RepeaterAction child returned failure - returning failure')
      self.counter = 0
      return res
    end
    
    error('Should not get here; res = ' .. res)
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function RepeaterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RepeaterAction
  --   print(twf.actionpath.action.RepeaterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RepeaterAction.name()
    return 'twf.actionpath.action.RepeaterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.child.Action:new(), times = 2})
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RepeaterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RepeaterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    resultTable.times = self.times
    resultTable.counter = self.counter
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.child.Action:new(), times = 2})
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RepeaterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function RepeaterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    local times = serTable.times
    local counter = serTable.counter
    
    return RepeaterAction:new({child = child, times = times, counter = counter})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeaterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeaterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RepeaterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RepeaterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RepeaterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return RepeaterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.RepeaterAction = RepeaterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DieOnFailureAction
--
-- Crash and burn if the child fails.
--
-- @remarks representative of skydiving
-----------------------------------------------------------------------------
if not twf.actionpath.action.DieOnFailureAction then
  local DieOnFailureAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DieOnFailureAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DieOnFailureAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DieOnFailureAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailureAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DieOnFailureAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    if type(o.child.name) ~= 'function' then 
      error('Expected o.child.name to be a function but is ' .. type(o.child.name))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DieOnFailureAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, crashes and burns if the 
  -- child returns failure
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DieOnFailureAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function DieOnFailureAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DieOnFailureAction start')
    self.logFile.writeLine('DieOnFailureAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.logFile.writeLine('DieOnFailureAction child returned success - returning success')
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('DieOnFailureAction child returned running - returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('DieOnFailureAction child returned failure - dieing')
      error('DieOnFailureAction - child returned failure')
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DieOnFailureAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DieOnFailureAction
  --   print(twf.actionpath.action.DieOnFailureAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DieOnFailureAction.name()
    return 'twf.actionpath.action.DieOnFailureAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailureAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailureAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailureAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DieOnFailureAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return DieOnFailureAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailureAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailureAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieOnFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieOnFailureAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieOnFailureAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return DieOnFailureAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.DieOnFailureAction = DieOnFailureAction
end


-----------------------------------------------------------------------------
-- twf.actionpath.action.RetryOnFailureAction
--
-- Try again if the child fails. Has a small delay before retrying
-----------------------------------------------------------------------------
if not twf.actionpath.action.RetryOnFailureAction then
  local RetryOnFailureAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  RetryOnFailureAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  RetryOnFailureAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this RetryOnFailureAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailureAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function RetryOnFailureAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function RetryOnFailureAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  
  -----------------------------------------------------------------------------
  -- Returns success or running if the child does, and running if the child 
  -- returns failure. Delays for 100ms if the child fails.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.RetryOnFailureAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -- @error  if the child returns failure
  -----------------------------------------------------------------------------
  function RetryOnFailureAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('RetryOnFailureAction start')
    self.logFile.writeLine('RetryOnFailureAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.actionpath.ActionResult.SUCCESS then 
      self.logFile.writeLine('RetryOnFailureAction child returned success - returning success')
      return res
    elseif res == twf.actionpath.ActionResult.RUNNING then 
      self.logFile.writeLine('RetryOnFailureAction child returned running - returning running')
      return res
    elseif res == twf.actionpath.ActionResult.FAILURE then 
      self.logFile.writeLine('RetryOnFailureAction child returned failure - returning running')
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
  function RetryOnFailureAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.RetryOnFailureAction
  --   print(twf.actionpath.action.RetryOnFailureAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function RetryOnFailureAction.name()
    return 'twf.actionpath.action.RetryOnFailureAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailureAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailureAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailureAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailureAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function RetryOnFailureAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return RetryOnFailureAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailureAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailureAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.RetryOnFailureAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.RetryOnFailureAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function RetryOnFailureAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return RetryOnFailureAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.RetryOnFailureAction = RetryOnFailureAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.MoveResultInterpreterAction
--
-- Returns success if the child action returns a successful move result - 
-- managing the interaction between actionpaths twf.movement.action.Action 
-- style classes.
-----------------------------------------------------------------------------
if not twf.actionpath.action.MoveResultInterpreterAction then
  local MoveResultInterpreterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  MoveResultInterpreterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  MoveResultInterpreterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this MoveResultInterpreterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then
      error('Expected o.child to be a table, but it is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful move result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('MoveResultInterpreterAction start')
    if fs.exists(stateTurtle.actionRecoveryFile) then 
      self.logFile.writeLine('MoveResultInterpreterAction action recovery file detected, recovering')
      local moved = stateTurtle:recoverAction()
      if moved then 
        self.logFile.writeLine('MoveResultInterpreterAction action recovery file indicates success - returning success')
        return twf.actionpath.ActionResult.SUCCESS
      end
      self.logFile.writeLine('MoveResultInterpreterAction action recovery file indicated failure - ignoring')
    end
    
    self.logFile.writeLine('MoveResultInterpreterAction ticking child (' .. self.child.name() .. ')')
    stateTurtle:prepareAction(self.child)
    local res = self.child:perform(stateTurtle, pathState)
    if twf.movement.MovementResult.isSuccess(res) then 
      self.logFile.writeLine('MoveResultInterpreterAction child returned ' .. twf.movement.MovementResult.toString(res) .. ' - returning success')
      self.child:updateState(stateTurtle, pathState)
      return twf.actionpath.ActionResult.SUCCESS
    else 
      self.logFile.writeLine('MoveResultInterpreterAction child returned ' .. twf.movement.MovementResult.toString(res) .. ' - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.MoveResultInterpreterAction
  --   print(twf.actionpath.action.MoveResultInterpreterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction.name()
    return 'twf.actionpath.action.MoveResultInterpreterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return MoveResultInterpreterAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MoveResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MoveResultInterpreterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MoveResultInterpreterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return MoveResultInterpreterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.MoveResultInterpreterAction = MoveResultInterpreterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DigResultInterpreterAction
--
-- Returns success if the child action returns a successful dig result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DigResultInterpreterAction then
  local DigResultInterpreterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DigResultInterpreterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DigResultInterpreterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- If no block is detected, the action is considered successful. Default true
  -----------------------------------------------------------------------------
  DigResultInterpreterAction.noBlockIsSuccess = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DigResultInterpreterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    if o.noBlockIsSuccess == nil then 
      o.noBlockIsSuccess = true
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful dig result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DigResultInterpreterAction start')
    self.logFile.writeLine('DigResultInterpreterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if res == twf.inventory.DigResult.DIG_SUCCESS then 
      self.logFile.writeLine('DigResultInterpreterAction child returned ' .. twf.inventory.DigResult.toString(res) .. ' - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    elseif self.noBlockIsSuccess and res == twf.inventory.DigResult.NOTHING_TO_DIG then 
      self.logFile.writeLine('DigResultInterpreterAction child returned ' .. twf.inventory.DigResult.toString(res) .. ' and noBlockIsSuccess=true - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else
      self.logFile.writeLine('DigResultInterpreterAction child returned ' .. twf.inventory.DigResult.toString(res) .. ' (noBlockIsSuccess = ' .. tostring(self.noBlockIsSuccess) .. ') - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DigResultInterpreterAction
  --   print(twf.actionpath.action.DigResultInterpreterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction.name()
    return 'twf.actionpath.action.DigResultInterpreterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    resultTable.noBlockIsSuccess = self.noBlockIsSuccess
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    local noBlockIsSuccess = serTable.noBlockIsSuccess
    
    return DigResultInterpreterAction:new({child = child, noBlockIsSuccess = noBlockIsSuccess})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DigResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DigResultInterpreterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DigResultInterpreterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return DigResultInterpreterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.DigResultInterpreterAction = DigResultInterpreterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.PlaceResultInterpreterAction
--
-- Returns success if the child action returns a successful place result
-----------------------------------------------------------------------------
if not twf.actionpath.action.PlaceResultInterpreterAction then
  local PlaceResultInterpreterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  PlaceResultInterpreterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  PlaceResultInterpreterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this PlaceResultInterpreterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful place result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('PlaceResultInterpreterAction start')
    self.logFile.writeLine('PlaceResultInterpreterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if twf.inventory.PlaceResult.isSuccess(res) then 
      self.logFile.writeLine('PlaceResultInterpreterAction child returned ' .. twf.inventory.PlaceResult.toString(res) .. ' - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else
      self.logFile.writeLine('PlaceResultInterpreterAction child returned ' .. twf.inventory.PlaceResult.toString(res) .. ' - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.PlaceResultInterpreterAction
  --   print(twf.actionpath.action.PlaceResultInterpreterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction.name()
    return 'twf.actionpath.action.PlaceResultInterpreterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return PlaceResultInterpreterAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.PlaceResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.PlaceResultInterpreterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function PlaceResultInterpreterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return PlaceResultInterpreterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.PlaceResultInterpreterAction = PlaceResultInterpreterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DropResultInterpreterAction
--
-- Returns success if the child action returns a successful drop result
-----------------------------------------------------------------------------
if not twf.actionpath.action.DropResultInterpreterAction then
  local DropResultInterpreterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DropResultInterpreterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  DropResultInterpreterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this DropResultInterpreterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action) but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful drop result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DropResultInterpreterAction start')
    self.logFile.writeLine('DropResultInterpreterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurle, pathState)
    
    if twf.inventory.DropResult.isSuccess(res) then 
      self.logFile.writeLine('DropResultInterpreterAction child returned ' .. twf.inventory.DropResult.toString(res) .. ' - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else
      self.logFile.writeLine('DropResultInterpreterAction child returned ' .. twf.inventory.DropResult.toString(res) .. ' - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DropResultInterpreterAction
  --   print(twf.actionpath.action.DropResultInterpreterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction.name()
    return 'twf.actionpath.action.DropResultInterpreterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return DropResultInterpreterAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropResultInterpreterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropResultInterpreterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return DropResultInterpreterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.DropResultInterpreterAction = DropResultInterpreterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.SuckResultInterpreterAction
--
-- Returns success if the child action returns a successful suck result
-----------------------------------------------------------------------------
if not twf.actionpath.action.SuckResultInterpreterAction then
  local SuckResultInterpreterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  SuckResultInterpreterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The child of this action
  -----------------------------------------------------------------------------
  SuckResultInterpreterAction.child = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this SuckResultInterpreterAction
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new({child = some.action.ActionName:new()})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -- @error   if o.child is nil
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.child) ~= 'table' then 
      error('Expected o.child to be a table (for an Action), but is a ' .. type(o.child))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:setLogFile(logFile)
    self.logFile = logFile
    if type(self.child.setLogFile) == 'function' then 
      self.child:setLogFile(logFile)
    end
  end
  
  -----------------------------------------------------------------------------
  -- Returns success if the child action returns a successful suck result, 
  -- failure otherwise
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May 
  --                    be modified to save state between calls, but should not 
  --                    break serialization with textutils.serialize
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('SuckResultInterpreterAction start')
    self.logFile.writeLine('SuckResultInterpreterAction ticking child (' .. self.child.name() .. ')')
    local res = self.child:perform(stateTurtle, pathState)
    
    if twf.inventory.SuckResult.isSuccess(res) then 
      self.logFile.writeLine('SuckResultInterpreterAction child returned ' .. twf.inventory.SuckResult.toString(res) .. ' - returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else
      self.logFile.writeLine('SuckResultInterpreterAction child returned ' .. twf.inventory.SuckResult.toString(res) .. ' - returning failure')
      return twf.actionpath.ActionResult.FAILURE
    end
  end
  
  -----------------------------------------------------------------------------
  -- No-op
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.SuckResultInterpreterAction
  --   print(twf.actionpath.action.SuckResultInterpreterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction.name()
    return 'twf.actionpath.action.SuckResultInterpreterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.child = actionPath:serializableObjectForAction(self.child)
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreterAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction.unserializeObject(serTable, actionPath)
    local child = actionPath:unserializeObjectOfAction(serTable.child)
    
    return SuckResultInterpreterAction:new({child = child})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreterAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.SuckResultInterpreterAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.SuckResultInterpreterAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function SuckResultInterpreterAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return SuckResultInterpreterAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.SuckResultInterpreterAction = SuckResultInterpreterAction
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  FuelCheckAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function FuelCheckAction:setLogFile(logFile)
    self.logFile = logFile
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
    self.logFile.writeLine('FuelCheckAction (fuelLevel = ' .. self.fuelLevel .. ') start')
    local turtleFuel = turtle.getFuelLevel()
    self.logFile.writeLine('FuelCheckAction turtle fuel level = ' .. turtleFuel)
    local succ = turtleFuel >= self.fuelLevel
    
    if succ then 
      self.logFile.writeLine('FuelCheckAction returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else 
      self.logFile.writeLine('FuelCheckAction returning failure')
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
  --   local act = twf.actionpath.action.FuelCheckAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.fuelLevel = self.fuelLevel
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function FuelCheckAction.unserializeObject(serTable, actionPath)
    local fuelLevel = serTable.fuelLevel
    
    return FuelCheckAction:new({fuelLevel = fuelLevel})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.FuelCheckAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.FuelCheckAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function FuelCheckAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return FuelCheckAction.unserializeObject(serTable, actionPath)
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  InventoryCheckAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function InventoryCheckAction:setLogFile(logFile)
    self.logFile = logFile
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
      for j = 1, #self.slots do 
        if self.slots[j] == i then 
          allowed = true
          break
        end
      end
      
      if not allowed then 
        inv:setItemDetailAt(i, nil)
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
    self.logFile.writeLine('InventoryCheckAction (countCheck = ' .. self.countCheck .. ') start')
    self.logFile.writeLine('InventoryCheckAction calculating relevant inventory')
    local relevantInventory = self:inventoryForSlots(stateTurtle)
    local totalCount = 0
    
    for i = 1, 16 do 
      local item = relevantInventory:getItemDetailAt(i)
      
      if item then
        if self:itemMatches(item) then 
          self.logFile.writeLine('InventoryCheckAction detected ' .. item:toString() .. ', which passed requirements')
          totalCount = totalCount + item.count
        else
          self.logFile.writeLine('InventoryCheckAction detected ' .. item:toString() .. ', but it didn\'t pass requirements')
        end
      end
    end
    
    self.logFile.writeLine('InventoryCheckAction determined that ' .. totalCount .. ' items pass requirements')
    
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
      self.logFile.writeLine('InventoryCheckAction returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else
      self.logFile.writeLine('InventoryCheckAction returning failure')
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
  --   local act = twf.actionpath.action.InventoryCheckAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.item = self.item
    resultTable.slots = self.slots
    resultTable.countCheck = self.countCheck
    resultTable.strict = self.strict
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function InventoryCheckAction.unserializeObject(serTable, actionPath)
    local item = serTable.item
    local slots = serTable.slots
    local countCheck = serTable.countCheck
    local strict = serTable.strict
    
    return InventoryCheckAction:new({item = item, slots = slots, countCheck = countCheck, strict = strict})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventoryCheckAction:new({child = some.action.ActionName:new()})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventoryCheckAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventoryCheckAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return InventoryCheckAction.unserializeObject(serTable, actionPath)
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  InventorySelectAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function InventorySelectAction:setLogFile(logFile)
    self.logFile = logFile
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
    self.logFile.writeLine('InventorySelectAction (slotIndex = ' .. self.slotIndex .. ') start')
    turtle.select(self.slotIndex)
    stateTurtle.selectedSlot = self.slotIndex
	  
    self.logFile.writeLine('InventorySelectAction returning success')
	  return twf.actionpath.ActionResult.SUCCESS
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
  --   local act = twf.actionpath.action.InventorySelectAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.slotIndex = self.slotIndex
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function InventorySelectAction.unserializeObject(serTable, actionPath)
    local slotIndex = serTable.slotIndex
    
    return InventorySelectAction:new({slotIndex = slotIndex})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 3})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.InventorySelectAction:new({slotIndex = 3})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.InventorySelectAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function InventorySelectAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return InventorySelectAction.unserializeObject(serTable, actionPath)
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
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DropAction.logFile = nil
  
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
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DropAction:setLogFile(logFile)
    self.logFile = logFile
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
    self.logFile.writeLine('DropAction drop (amount = ' .. tostring(amount) .. ') start')
    local delegate = twf.inventory.action.DropAction:new({direction = self.direction, amount = amount})
    local res, item = delegate:perform(stateTurtle, pathState)
    
    self.logFile.writeLine('DropAction drop delegate returned ' .. twf.inventory.DropResult.toString(res))
    if twf.inventory.DropResult.isSuccess(res) then 
      self.logFile.writeLine('DropAction drop returning (success, ' .. (type(item) ~= 'table' and tostring(item) or item:toString()) .. ')')
      return twf.actionpath.ActionResult.SUCCESS, item
    else 
      self.logFile.writeLine('DropAction drop returning (failure, ' .. (type(item) ~= 'table' and tostring(item) or item:toString()) .. ')')
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
    self.logFile.writeLine('DropAction dropBySlot (slots = ' .. textutils.serialize(self.slots) .. ') start')
    for i = 1, #self.slots do 
      self.logFile.writeLine('DropAction dropBySlot selecting ' .. self.slots[i])
      stateTurtle:selectSlot(self.slots[i])
      
      self.logFile.writeLine('DropAction dropBySlot dropping from current slot')
      local res, item = self:drop(stateTurtle, pathState)
      if res == twf.actionpath.ActionResult.FAILURE then 
        self.logFile.writeLine('DropAction dropBySlot failed to drop from current slot')
        return res
      end
    end
    self.logFile.writeLine('DropAction dropBySlot returning success')
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
    local inspect = dofile('inspect.lua')
    if not inspect then inspect = textutils.serialize end
    
    -- This line is long because its mostly just prettifying the text. If inspect.lua is available, it uses it to print the items in one line (ignoring metatables)
    -- otherwise, it falls back to textutils (which clutters the logfile more)
    self.logFile.writeLine('DropAction dropByItem (#items = ' .. #self.items .. ') start')
    for i = 1, #self.items do 
      self.logFile.writeLine('DropAction dropping ' .. self.items[i].name 'x' .. self.items[i].count)
      
      local toDrop = self.items[i].count
      local nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      
      while nextIndex > 0 and toDrop > 0 do 
        self.logFile.writeLine('DropAction dropByItem loop (i = ' .. i .. ', toDrop = ' .. toDrop .. ', nextIndex = ' .. nextIndex .. ') start')
        self.logFile.writeLine('DropAction dropByItem loop selecting ' .. nextIndex)
        stateTurtle:selectSlot(nextIndex)
        
        self.logFile.writeLine('DropAction dropByItem loop dropping ' .. toDrop)
        local res, item = self:drop(stateTurtle, pathState, toDrop)
        
        if res == twf.actionpath.ActionResult.FAILURE then 
          self.logFile.writeLine('DropAction dropByItem loop drop returned failure - returning failure')
          return res
        end
        
        if not item then 
          error('Weird state, res is failure but item is nil!')
        end
        
        toDrop = toDrop - item.count
        nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      end
      self.logFile.writeLine('DropAction dropByItem loop end (toDrop = ' .. toDrop .. ', nextIndex = ' .. nextIndex ..')')
    end
    
    self.logFile.writeLine('DropAction dropByItem returning success')
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
    self.logFile.writeLine('DropAction dropByItemType (#items = ' .. #self.items .. ') start')
    for i = 1, #self.items do 
      self.logFile.writeLine('DropAction dropByItemType dropping all of ' .. self.items[i].name)
      local nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      
      while nextIndex > 0 do 
        self.logFile.writeLine('DropAction dropByItemType loop (i = ' .. i .. ', nextIndex = ' .. nextIndex .. ') start')
        
        self.logFile.writeLine('DropAction dropByItemType loop selecting ' .. nextIndex)
        stateTurtle:selectSlot(nextIndex)
        
        self.logFile.writeLine('DropAction dropByItemType loop dropping')
        local res, item = self:drop(stateTurtle, pathState, toDrop)
        
        if res == twf.actionpath.ActionResult.FAILURE then
          self.logFile.writeLine('DropAction dropByItemType loop drop returned failure - returning failure')        
          return res
        end
        
        nextIndex = stateTurtle.inventory:firstIndexOf(self.items[i], self.itemStrict)
      end
      
      self.logFile.writeLine('DropAction dropByItemType loop end (nextIndex = ' .. nextIndex .. ')')
    end
    
    self.logFile.writeLine('DropAction dropByItemType returning success')
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
    self.logFile.writeLine('DropAction dropByExceptItemType start')
    
    for i = 1, 16 do 
      self.logFile.writeLine('DropAction dropByExceptItemType loop (i=' .. i .. ') start')
      self.logFile.writeLine('DropAction dropByExceptItemType loop checking item at slot ' .. i)
      local item = stateTurtle.inventory:getItemDetailAt(i)
      
      if item then 
        self.logFile.writeLine('DropAction dropByExceptItemType loop item name = ' .. item.name)
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
          self.logFile.writeLine('DropAction dropByExceptItemType loop item not banned, selecting slot ' .. i)
          stateTurtle:selectSlot(i)
          self.logFile.writeLine('DropAction dropByExceptItemType loop dropping')
          local res, item = self:drop(stateTurtle, pathState)
          
          if res == twf.actionpath.ActionResult.FAILURE then 
            self.logFile.writeLine('DropAction dropByExceptItemType loop drop returned failure - returning failure')
            return res 
          end
        else 
          self.logFile.writeLine('DropAction dropByExceptItemType loop item banned! not dropping')
        end
      else
        self.logFile.writeLine('DropAction dropByExceptItemType loop nothing at slot ' .. i)
      end
    end
    self.logFile.writeLine('DropAction dropByExceptItemType loop end')
    self.logFile.writeLine('DropAction dropByExceptItemType returning success')
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
    self.logFile.writeLine('DropAction dropByAll start')
    local nextIndex = stateTurtle.inventory:firstIndexOfFilledSlot()
    
    while nextIndex > 0 do 
      self.logFile.writeLine('DropAction dropByAll loop (nextIndex = ' .. nextIndex .. ') start')
      self.logFile.writeLine('DropAction dropByAll loop selecting slot ' .. nextIndex)
      stateTurtle:selectSlot(nextIndex)
      
      self.logFile.writeLine('DropAction dropByAll loop dropping')
      local res, item = self:drop(stateTurtle, pathState)
      
      if res == twf.actionpath.ActionResult.FAILURE then 
        self.logFile.writeLine('DropAction dropByAll loop drop returned failure - returning failure')
        return res
      end
      
      nextIndex = stateTurtle.inventory:firstIndexOfFilledSlot()
    end
    self.logFile.writeLine('DropAction dropByAll loop end')
    self.logFile.writeLine('DropAction dropByAll returning success') 
    return twf.actionpath.ActionResult.SUCCESS
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
    self.logFile.writeLine('DropAction (dropBy = ' .. self.dropBy .. ', direction = ' .. twf.movement.direction.toString(self.direction) .. ') start')
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
  --   local act = twf.actionpath.action.DropAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.dropBy = self.dropBy
    resultTable.direction = self.direction
    resultTable.slots = self.slots
    
    if self.items then 
      resultTable.items = {}
      for i = 1, #self.items do 
        resultTable.items[i] = self.items[i]:serializableObject()
      end
    end
    
    resultTable.itemStrict = self.itemStrict
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserializeObject(serialized)
  --
  -- @param serTable the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DropAction.unserializeObject(serTable, actionPath)
    local dropBy = serTable.dropBy
    local direction = serTable.direction
    local slots = serTable.slots
    
    local items = nil
    if serTable.items then 
      items = {}
      for i = 1, #serTable.items do 
        items[i] = twf.inventory.ItemDetail.unserializeObject(serTable.items[i])
      end
    end
    
    local itemStrict = serTable.itemStrict 
    
    return DropAction:new({
      dropBy = dropBy,
      direction = direction,
      slots = slots,
      items = items,
      itemStrict = itemStrict
    })
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({dropBy = 'all'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DropAction:new({dropBy = 'all'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DropAction.unserialize(serialized)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DropAction.unserialize(serialized, actionPath)
    local serTable = textutils.unserialize(serialized)
    
    return DropAction.unserializeObject(serTable, actionPath)
  end
  
  twf.actionpath.action.DropAction = DropAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.CounterAction
-- 
-- Performs actions on counters. Allows for simply loops. Counters are
-- treated like 0 if they are not set
-----------------------------------------------------------------------------
if not twf.actionpath.action.CounterAction then
  local CounterAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  CounterAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The id of the counter. 
  -----------------------------------------------------------------------------
  CounterAction.id = nil
  
  -----------------------------------------------------------------------------
  -- The number to compare with
  -----------------------------------------------------------------------------
  CounterAction.number = nil
  
  -----------------------------------------------------------------------------
  -- The method used to compare. Any of:
  --   'equals'      - success on the counter being equal to the number
  --   'greaterThan' - success on the counter being strictly greater than the number
  --   'lessThan'    - success on the counter being strictly less than the number
  --   'set'         - sets the counter to this number
  --   'add'         - adds to the counter by this number. 
  -----------------------------------------------------------------------------
  CounterAction.actionType = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.CounterAction:new({id = 'my_counter', number = 1, actionType = 'add' })
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -----------------------------------------------------------------------------
  function CounterAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.id) ~= 'string' then 
      error('Expected o.id to be a string, but it is ' .. type(o.id))
    end
    
    if type(o.number) ~= 'number' then 
      error('Expected o.number to be a number, but it is ' .. type(o.id))
    end
    
    if type(o.actionType) ~= 'string' then 
      error('Expected o.actionType to be a string, but it is ' .. type(o.actionType))
    end
    
    local actionTypeValid =              o.actionType == 'equals'
    actionTypeValid = actionTypeValid or o.actionType == 'greaterThan'
    actionTypeValid = actionTypeValid or o.actionType == 'lessThan'
    actionTypeValid = actionTypeValid or o.actionType == 'set'
    actionTypeValid = actionTypeValid or o.actionType == 'add'
    
    if not actionTypeValid then 
      error('Expected o.actionType to be \'equals\', \'greaterThan\', \'lessThan\', \'set\', or \'add\' but is \'' .. o.actionType .. '\'')
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function CounterAction:setLogFile(logFile)
    self.logFile = logFile
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. 
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.CounterAction:new({id = 'my_counter'})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -----------------------------------------------------------------------------
  function CounterAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('CounterAction (id = ' .. self.id .. ', actionType = ' .. self.actionType .. ', number = ' .. self.number .. ') start')
    if not pathState.counters then 
      pathState.counters = {}
    end
    
    if pathState.counters[self.id] == nil then 
      pathState.counters[self.id] = 0 
    end
    
    self.logFile.writeLine('CounterAction loaded counter; value = ' .. pathState.counters[self.id])
    if self.actionType == 'equals' then 
      if pathState.counters[self.id] == self.number then 
        self.logFile.writeLine('CounterAction returning success')
        return twf.actionpath.ActionResult.SUCCESS
      else 
        self.logFile.writeLine('CounterAction returning failure')
        return twf.actionpath.ActionResult.FAILURE
      end
    elseif self.actionType == 'greaterThan' then 
      if pathState.counters[self.id] > self.number then 
        self.logFile.writeLine('CounterAction returning success')
        return twf.actionpath.ActionResult.SUCCESS
      else 
        self.logFile.writeLine('CounterAction returning failure')
        return twf.actionpath.ActionResult.FAILURE
      end
    elseif self.actionType == 'lessThan' then 
      if pathState.counters[self.id] == self.number then 
        self.logFile.writeLine('CounterAction returning success')
        return twf.actionpath.ActionResult.SUCCESS
      else 
        self.logFile.writeLine('CounterAction returning failure')
        return twf.actionpath.ActionResult.FAILURE
      end
    elseif self.actionType == 'set' then 
      self.logFile.writeLine('CounterAction setting counter to ' .. self.number)
      pathState.counters[self.id] = self.number
      
      self.logFile.writeLine('CounterAction returning success')
      return twf.actionpath.ActionResult.SUCCESS
    elseif self.actionType == 'add' then 
      self.logFile.writeLine('CounterAction setting counter to ' .. (pathState.counters[self.id] + self.number))
      pathState.counters[self.id] = pathState.counters[self.id] + self.number
      
      self.logFile.writeLine('CounterAction returning success')
      return twf.actionpath.ActionResult.SUCCESS
    else 
      error('Unexpected action type in CounterAction:perform!')
    end
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function CounterAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.CounterAction
  --   print(twf.actionpath.action.CounterAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function CounterAction.name()
    return 'twf.actionpath.action.CounterAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.CounterAction:new({id = 'my_counter', actionType = 'set', number = 64})
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.CounterAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function CounterAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.id = self.id 
    resultTable.actionType = self.actionType
    resultTable.number = self.number
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.Action:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function CounterAction.unserializeObject(serialized, actionPath)
    local id = serialized.id
    local actionType = serialized.actionType
    local number = serialized.number
    
    return CounterAction:new({id = id, actionType = actionType, number = number})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.CounterAction:new({id = 'my_counter', actionType = 'add', number = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.Action.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function CounterAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.CounterAction:new({id = 'my_counter', actionType = 'add', number = 1})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.CounterAction.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function CounterAction.unserialize(serialized, actionPath)
    return CounterAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.actionpath.action.CounterAction = CounterAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.DieAction
--
-- Dies, optionally printing a message
-----------------------------------------------------------------------------
if not twf.actionpath.action.DieAction then
  local DieAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  DieAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The message to display 
  -----------------------------------------------------------------------------
  DieAction.message = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieAction:new()
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -----------------------------------------------------------------------------
  function DieAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if not o.message then 
      o.message = 'DieAction reached'
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function DieAction:setLogFile(logFile)
    self.logFile = logFile
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. Never returns
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.DieAction:new({id = 'my_counter'})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -- @error always
  -----------------------------------------------------------------------------
  function DieAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('DieAction (message = ' .. self.message .. ') start')
    self.logFile.writeLine('DieAction dieing')
    error(self.message)
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function DieAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.DieAction
  --   print(twf.actionpath.action.DieAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function DieAction.name()
    return 'twf.actionpath.action.DieAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DieAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DieAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.message = self.message
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.DieAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function DieAction.unserializeObject(serialized, actionPath)
    local message = serialized.message
    
    return DieAction:new({message = message})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function DieAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.DieAction:new()
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.DieAction.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function DieAction.unserialize(serialized, actionPath)
    return DieAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.actionpath.action.DieAction = DieAction
end

-----------------------------------------------------------------------------
-- twf.actionpath.action.MessageAction
--
-- Prints a message
-----------------------------------------------------------------------------
if not twf.actionpath.action.MessageAction then
  local MessageAction = {}

  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  MessageAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The log file handle for this action. May be nil
  -----------------------------------------------------------------------------
  MessageAction.logFile = nil
  
  -----------------------------------------------------------------------------
  -- The message to display 
  -----------------------------------------------------------------------------
  MessageAction.message = nil
  
  -----------------------------------------------------------------------------
  -- Creates a new instance of this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MessageAction:new({message = 'hi'})
  --
  -- @param o superseding object
  -- @return  a new instance of this action
  -----------------------------------------------------------------------------
  function MessageAction:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    if type(o.message) ~= 'string' then 
      error('Expected o.message to be a string but got ' .. type(o.message))
    end
    
    return o
  end
  
  -----------------------------------------------------------------------------
  -- Sets the log file for this action and its children, if any
  --
  -- @param logFile the log file
  -----------------------------------------------------------------------------
  function MessageAction:setLogFile(logFile)
    self.logFile = logFile
  end
  
  -----------------------------------------------------------------------------
  -- Performs this action. Returns success
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local st = twf.movement.StatefulTurtle:new()
  --   local act = twf.actionpath.action.MessageAction:new({message = 'hi'})
  --   local res = act:perform(st, {})
  --
  -- @param stateTurtle StatefulTurtle
  -- @param pathState   an object containing the state of this actionpath. May be
  --                    modified to save state between calls, but should not break
  --                    serialization with textutils.serialize
  --
  -- @return result of this action 
  -- @error always
  -----------------------------------------------------------------------------
  function MessageAction:perform(stateTurtle, pathState)
    self.logFile.writeLine('MessageAction (message = ' .. self.message .. ') start')
    self.logFile.writeLine('MessageAction printing')
    print(self.message)
    
    self.logFile.writeLine('MessageAction returning success')
    return twf.actionpath.ActionResult.SUCCESS
  end
  
  -----------------------------------------------------------------------------
  -- Unused
  -- 
  -- @param stateTurtle the state turtle to update
  -- @param pathState   the path state
  -----------------------------------------------------------------------------
  function MessageAction:updateState(stateTurtle, pathState)
  end
  
  -----------------------------------------------------------------------------
  -- Returns a unique name for this type of action.
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   -- prints twf.actionpath.action.MessageAction
  --   print(twf.actionpath.action.MessageAction.name())
  --
  -- @return a unique name for this type of action.
  -----------------------------------------------------------------------------
  function MessageAction.name()
    return 'twf.actionpath.action.MessageAction'
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MessageAction:new()
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.MessageAction.unserializeObject(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function MessageAction:serializableObject(actionPath)
    local resultTable = {}
    
    resultTable.message = self.message
    
    return resultTable
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serializableObject
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MessageAction:new({message = 'hi'})
  --   local serialized = act:serializableObject(actPath)
  --   local unserialized = twf.actionpath.action.MessageAction.unserializeObject(serialized)
  --
  -- @param serialized the serialized object
  -- @param actionPath the action path 
  -- @return serialized action
  -----------------------------------------------------------------------------
  function MessageAction.unserializeObject(serialized, actionPath)
    local message = serialized.message
    
    return MessageAction:new({message = message})
  end
  
  -----------------------------------------------------------------------------
  -- Serializes this action
  --
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MessageAction:new({message = 'hi'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MessageAction.unserialize(serialized)
  --
  -- @param actionPath the action path, used for serializing children
  -- @return           string serialization of this action
  -----------------------------------------------------------------------------
  function MessageAction:serialize(actionPath)
    return textutils.serialize(self:serializableObject())
  end
  
  -----------------------------------------------------------------------------
  -- Unserializes an action serialized by this action types serialize
  -- 
  -- Usage:
  --   dofile('twf_actionpath.lua')
  --   local act = twf.actionpath.action.MessageAction:new({message = 'hi'})
  --   local serialized = act:serialize(actPath)
  --   local unserialized = twf.actionpath.action.MessageAction.unserialize(serialized, actPath)
  --
  -- @param serialized the serialized string
  -- @param actionPath the action path 
  -- @return string serialization of this action
  -----------------------------------------------------------------------------
  function MessageAction.unserialize(serialized, actionPath)
    return MessageAction.unserializeObject(textutils.unserialize(serialized), actionPath)
  end
  
  twf.actionpath.action.MessageAction = MessageAction
end